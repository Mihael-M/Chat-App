//
//  DataStorageService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class DataStorageService: ObservableObject {
    @Published var currentUser: MyUser?
    
    static var currentUserID: String {
        shared.currentUser?.id ?? ""
    }
    
    static var shared = DataStorageService()
    
    @Published var users: [MyUser] = [] // not including current user
    @Published var allUsers: [MyUser] = []
    
    @Published var conversations: [Conversation] = []
    
    init() {
        getData()
    }
    
    @MainActor
    func loadCurrentUserData() async throws {
        guard let currentUID = AuthenticationService.shared.userSession?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUID).getDocument()
        self.currentUser = MyUser(dictionary: snapshot.data() ?? [:])
    }
    
    func loadAllUserData() async throws -> [MyUser] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ MyUser(dictionary: $0.data()) })
    }
    
    func getUsers() async {
        let snapshot = try? await Firestore.firestore()
            .collection("users")
            .getDocuments()
        storeUsers(snapshot)
    }
    
    func getConversations() async {
        let snapshot = try? await Firestore.firestore()
            .collection("conversations")
            .whereField("users", arrayContains: DataStorageService.currentUserID)
            .getDocuments()
        storeConversations(snapshot)
    }
    
    func subscribeToUpdates() {
        Firestore.firestore()
            .collection("users")
            .addSnapshotListener { [weak self] (snapshot, _) in
                guard let self else { return }
                self.storeUsers(snapshot)
                Task {
                    await self.getConversations() // update in case some new user didn't make it in time for conversations subscription
                }
            }
        
        Firestore.firestore()
            .collection("conversations")
            .whereField("users", arrayContains: DataStorageService.currentUserID)
            .addSnapshotListener() { [weak self] (snapshot, _) in
                self?.storeConversations(snapshot)
            }
    }
    
    func reset() {
        self.currentUser = nil
        self.conversations = []
        self.allUsers = []
        self.users = []
    }
    
    private func storeUsers(_ snapshot: QuerySnapshot?) {
        guard let currentUser = self.currentUser else { return }
        DispatchQueue.main.async { [weak self] in
            let users: [MyUser] = snapshot?.documents
                .compactMap { MyUser(dictionary: $0.data()) } ?? []
            
            self?.users = users
            self?.allUsers = users + [currentUser]
        }
    }
    
    private func storeConversations(_ snapshot: QuerySnapshot?) {
        DispatchQueue.main.async { [weak self] in
            self?.conversations = snapshot?.documents
                .compactMap { [weak self] document in
                    do {
                        let firestoreConversation = try document.data(as: FirestoreConversation.self)
                        return self?.makeConversation(document.documentID, firestoreConversation)
                    } catch {
                        print(error)
                    }
                    
                    return nil
                }.sorted {
                    if let date1 = $0.latestMessage?.createdAt, let date2 = $1.latestMessage?.createdAt {
                        return date1 > date2
                    }
                    return $0.displayTitle < $1.displayTitle
                }
            ?? []
        }
    }
    
    private func makeConversation(_ id: String, _ firestoreConversation: FirestoreConversation) -> Conversation {
        var message: LatestMessageInChat? = nil
        if let flm = firestoreConversation.latestMessage,
           let user = allUsers.first(where: { $0.id == flm.userId }) {
            var subtext: String?
            if !flm.attachments.isEmpty, let first = flm.attachments.first {
                subtext = first.type.title
            } else if flm.recording != nil {
                subtext = "Voice recording"
            }
            message = LatestMessageInChat(
                senderName: user.base.name,
                createdAt: flm.createdAt,
                text: flm.text.isEmpty ? nil : flm.text,
                subtext: subtext
            )
        }
        let users = firestoreConversation.users.compactMap { id in
            allUsers.first(where: { $0.id == id })
        }
        let conversation = Conversation(
            id: id,
            users: users,
            usersUnreadCountInfo: firestoreConversation.usersUnreadCountInfo,
            isGroup: firestoreConversation.isGroup,
            pictureURL: URL(string: firestoreConversation.pictureURL ?? "defaultavatar"),
            title: firestoreConversation.title,
            latestMessage: message
        )
        return conversation
    }
    
    private func getData() {
        Task {
            await getUsers()
            await getConversations()
        }
    }
}
