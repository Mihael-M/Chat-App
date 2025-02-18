//
//  AddChatViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//
import SwiftUI
import FirebaseFirestore
import ExyteMediaPicker
import ExyteChat

class AddChatViewModel: ObservableObject {

    @Published var searchableText: String = ""

    // group creation
    @Published var selectedUsers: [MyUser] = []
    @Published var picture: Media?
    @Published var title: String = ""

    var filteredUsers: [MyUser] {
        if searchableText.isEmpty {
            return DataStorageService.shared.users
        }
        return DataStorageService.shared.users.filter {
            $0.base.name.lowercased().contains(searchableText.lowercased())
        }
    }

    func conversationForUsers(_ users: [MyUser]) async -> Conversation? {
        // search in existing conversations
        for conversation in DataStorageService.shared.conversations {
            if conversation.users.count - 1 == users.count { // without current user
                var foundIt = true
                for user in users {
                    if !conversation.users.contains(user) {
                        foundIt = false
                        break
                    }
                }
                if foundIt {
                    return conversation
                }
            }
        }

        // create new one for group
        if users.count > 1 {
            return await createConversation(users)
        }

        // only create individual when first message is sent, not here (ConversationViewModel)
        return nil
    }

    func createConversation(_ users: [MyUser]) async -> Conversation? {
        let pictureURL = await UploadingService.uploadImageMedia(picture)
        return await createConversation(users, pictureURL)
    }

    private func createConversation(_ users: [MyUser], _ pictureURL: URL?) async -> Conversation? {
        let allUserIds = users.map { $0.id } + [DataStorageService.currentUserID]
        let dict: [String : Any] = [
            "users": allUserIds,
            "usersUnreadCountInfo": Dictionary(uniqueKeysWithValues: allUserIds.map { ($0, 0) } ),
            "isGroup": true,
            "pictureURL": pictureURL?.absoluteString ?? "",
            "title": title
        ]

        return await withCheckedContinuation { continuation in
            var ref: DocumentReference? = nil
            ref = Firestore.firestore()
                .collection("conversations")
                .addDocument(data: dict) { err in
                    if let _ = err {
                        continuation.resume(returning: nil)
                    } else if let id = ref?.documentID {
                        if let current = DataStorageService.shared.currentUser {
                            continuation.resume(returning: Conversation(id: id, users: users + [current], isGroup: true, pictureURL: pictureURL, title: self.title))
                        }
                    }
                }
        }
    }
}
