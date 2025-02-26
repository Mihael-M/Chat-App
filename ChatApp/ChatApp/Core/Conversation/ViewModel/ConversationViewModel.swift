//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//
//
import Foundation
import FirebaseFirestore
import ExyteChat

@MainActor
class ConversationViewModel: ObservableObject {

    var users: [MyUser] // not including current user
    var allUsers: [MyUser]

    var conversationId: String?
    var conversation: Conversation? {
        if let id = conversationId {
            return DataStorageService.shared.conversations.first(where: { $0.id == id })
        }
        return nil
    }

    private var conversationDocument: DocumentReference?
    private var messagesCollection: CollectionReference?

    @Published var messages: [Message] = []

    var lock = NSRecursiveLock()

    private var subscriptionToConversationCreation: ListenerRegistration?

    init(user: MyUser) {
        self.users = [user]
        self.allUsers = [user]
        if let currentUser = DataStorageService.shared.currentUser {
            self.allUsers.append(currentUser)
        }
        // setup conversation and messagesCollection later, after it's created
        // either when another user creates it by sending the first message
        subscribeToConversationCreation(user: user)
        // or when this user sends first message
    }

    init(conversation: Conversation) {
        self.users = conversation.users.filter { $0.id != DataStorageService.currentUserID }
        self.allUsers = conversation.users
        updateForConversation(conversation)
    }

    func updateForConversation(_ conversation: Conversation) {
        self.conversationId = conversation.id
        makeFirestoreReferences(conversation.id)
        subscribeToMessages()
    }

    func makeFirestoreReferences(_ conversationId: String) {
        self.conversationDocument = Firestore.firestore()
            .collection("conversations")
            .document(conversationId)

        self.messagesCollection = Firestore.firestore()
            .collection("conversations")
            .document(conversationId)
            .collection("messages")
    }
    func resetUnreadCounter() {
        if var usersUnreadCountInfo = conversation?.usersUnreadCountInfo {
            usersUnreadCountInfo[DataStorageService.currentUserID] = 0
            conversationDocument?.updateData(["usersUnreadCountInfo" : usersUnreadCountInfo])
        }
    }

    func bumpUnreadCounters() {
        if var usersUnreadCountInfo = conversation?.usersUnreadCountInfo {
            usersUnreadCountInfo = usersUnreadCountInfo.mapValues { $0 + 1 }
            usersUnreadCountInfo[DataStorageService.currentUserID] = 0
            conversationDocument?.updateData(["usersUnreadCountInfo" : usersUnreadCountInfo])
        }
    }

    // MARK: - get/send messages

    func subscribeToMessages() {
        messagesCollection?
            .order(by: "createdAt", descending: false)
            .addSnapshotListener() { [weak self] (snapshot, _) in
                guard let self = self else { return }
                let messages = snapshot?.documents
                    .compactMap { try? $0.data(as: FirestoreMessage.self) }
                    .compactMap { firestoreMessage -> Message? in
                        guard
                            let id = firestoreMessage.id,
                            let user = self.allUsers.first(where: { $0.id == firestoreMessage.userId }),
                            let date = firestoreMessage.createdAt
                        else { return nil }

                        let convertAttachments: ([FirestoreAttachment]) -> [Attachment] = { attachments in
                            attachments.compactMap {
                                if let thumbURL = URL(string:$0.thumbURL), let url = URL(string: $0.url) {
                                    return Attachment(id: UUID().uuidString, thumbnail: thumbURL, full: url, type: $0.type)
                                }
                                return nil
                            }
                        }

                        let convertRecording: (FirestoreRecording?) -> Recording? = { recording in
                            if let recording = recording {
                                return Recording(duration: recording.duration, waveformSamples: recording.waveformSamples, url: URL( string: recording.url))
                            }
                            return nil
                        }

                        var replyMessage: ReplyMessage?
                        if let reply = firestoreMessage.replyMessage,
                           let replyId = reply.id,
                           let replyCreatedAt = reply.createdAt,
                           let replyUser = self.allUsers.first(where: { $0.id == reply.userId }) {
                            replyMessage = ReplyMessage(
                                id: replyId,
                                user: replyUser.base,
                                createdAt: replyCreatedAt,
                                text: reply.text,
                                attachments: convertAttachments(reply.attachments),
                                recording: convertRecording(reply.recording))
                        }

                        return Message(
                            id: id,
                            user: user.base,
                            status: .sent,
                            createdAt: date,
                            text: firestoreMessage.text,
                            attachments: convertAttachments(firestoreMessage.attachments),
                            recording: convertRecording(firestoreMessage.recording),
                            replyMessage: replyMessage)
                    } ?? []

                self.lock.withLock {
                    // insert messages which are still sending
                    let localMessages = self.messages
                        .filter { $0.status != .sent }
                        .filter { localMessage in
                            messages.firstIndex { message in
                                message.id == localMessage.id
                            } == nil
                        }
                        .sorted { $0.createdAt < $1.createdAt }
                    self.messages = messages + localMessages
                }
            }
    }

    func sendMessage(_ draft: DraftMessage) {
        Task {
            /// Create conversation in Firestore if needed
//            if conversation == nil, users.count == 1, let user = users.first,
//                let conversation = await createIndividualConversation(user) {
//                updateForConversation(conversation)
//            }

            /// Precreate user message
            guard let currentUser = DataStorageService.shared.currentUser else { return }
            let messageId = UUID().uuidString
            let userMessage = await Message.makeMessage(id: messageId, user: currentUser.base, status: .sending, draft: draft)
           
            lock.withLock {
                messages.append(userMessage)
            }
            
            /// Convert to Firestore dictionary
            let messageDict = await makeDraftMessageDictionary(draft)

            /// Save user message in Firestore
            do {
                try await messagesCollection?.document(messageId).setData(messageDict)
            } catch {
                print("Error sending message: \(error)")
                lock.withLock {
                    if let index = messages.lastIndex(where: { $0.id == messageId }) {
                        messages[index].status = .error(draft)
                    }
                }
            }
            
            /// update latest message in current conversation to be this one
            if let id = conversation?.id {
                            try await Firestore.firestore()
                                .collection("conversations")
                                .document(id)
                                .updateData(["latestMessage" : messageDict])
                        }
            
            /// Update unread message counters for other participants
            bumpUnreadCounters()
        }
    }

    func sendAIMessage(_ responseText: String) async throws{
        guard let aiUser = await DataStorageService.shared.getAIUser() else { return }

        let messageId = UUID().uuidString
        let aiMessage = Message(
            id: messageId,
            user: aiUser.base,
            status: .sent,
            createdAt: Date(),
            text: responseText,
            attachments: [],
            recording: nil,
            replyMessage: nil
        )

        lock.withLock {
            messages.append(aiMessage)
        }

        let messageDict: [String: Any] = [
            "userId": aiUser.id,
            "createdAt": Timestamp(date: Date()),
            "text": responseText,
            "attachments": []
        ]

        do {
            try await messagesCollection?.document(messageId).setData(messageDict)
            print("✅ AI message saved to Firestore.")
        } catch {
            print("❌ Error saving AI message: \(error)")
        }
        do{
            if let id = conversation?.id {
                try await Firestore.firestore()
                    .collection("conversations")
                    .document(id)
                    .updateData(["latestMessage" : messageDict])
            }
        }
        catch{
            print("Erro obtaining id: \(error)")
        }
    }
    
    private func makeDraftMessageDictionary(_ draft: DraftMessage) async -> [String: Any] {
        guard let user = DataStorageService.shared.currentUser else { return [:] }
        var attachments = [[String: Any]]()
        for media in draft.medias {
            let thumbURL, fullURL : URL?
            switch media.type {
            case .image:
                thumbURL = await UploadingService.uploadImageMedia(media)
                fullURL = thumbURL
            case .video:
                (thumbURL, fullURL) = await UploadingService.uploadVideoMedia(media)
            }

            if let thumbURL, let fullURL {
                attachments.append([
                    "thumbURL": thumbURL.absoluteString,
                    "url": fullURL.absoluteString,
                    "type": AttachmentType(mediaType: media.type).rawValue
                ])
            }
        }

        var recordingDict: [String: Any]? = nil
        if let recording = draft.recording, let url = await UploadingService.uploadRecording(recording) {
            recordingDict = [
                "duration": recording.duration,
                "waveformSamples": recording.waveformSamples,
                "url": url.absoluteString
            ]
        }

        var replyDict: [String: Any]? = nil
        if let reply = draft.replyMessage {
            var replyRecordingDict: [String: Any]? = nil
            if let recording = reply.recording {
                replyRecordingDict = [
                    "duration": recording.duration,
                    "waveformSamples": recording.waveformSamples,
                    "url": recording.url?.absoluteString ?? ""
                ]
            }

            replyDict = [
                "id": reply.id,
                "userId": reply.user.id,
                "text": reply.text,
                "attachments": reply.attachments.map { [
                    "url": $0.full.absoluteString,
                    "type": $0.type.rawValue
                ] },
                "recording": replyRecordingDict as Any
            ]
        }

        return [
            "userId": user.id,
            "createdAt": Timestamp(date: draft.createdAt),
            "isRead": Timestamp(date: draft.createdAt),
            "text": draft.text,
            "attachments": attachments,
            "recording": recordingDict as Any,
            "replyMessage": replyDict as Any
        ]
    }

    // MARK: - conversation life management

    func subscribeToConversationCreation(user: MyUser) {
        subscriptionToConversationCreation = Firestore.firestore()
            .collection("conversations")
            .whereField("users", arrayContains: DataStorageService.currentUserID)
            .addSnapshotListener() { [weak self] (snapshot, _) in
                // check if this conversation was created by another user already
                if let conversation = self?.conversationForUser(user) {
                    self?.updateForConversation(conversation)
                    self?.subscriptionToConversationCreation = nil
                }
            }
    }

    private func conversationForUser(_ user: MyUser) -> Conversation? {
        // check in case the other user sent a message while this user had the empty conversation open
        for conversation in DataStorageService.shared.conversations {
            if !conversation.isGroup, conversation.users.contains(user) {
                return conversation
            }
        }
        return nil
    }

}
