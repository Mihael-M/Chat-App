//
//  ChatInboxViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Combine
import ExyteChat

@MainActor
class ChatInboxViewModel: ObservableObject {
    @Published var currentUser: MyUser?
    @Published var conversations: [Conversation] = []
    @Published var allMessages: [Message] = [] // Stores all messages
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()

    init() {
        Task {
            setupSubscribers()
            await fetchAllMessages() // Fetch all messages on init
        }
    }

    private func setupSubscribers() {
        DataStorageService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)

        DataStorageService.shared.$conversations.sink { [weak self] conversations in
            self?.conversations = conversations
        }.store(in: &cancellables)
    }

    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return self.conversations
        }
        return self.conversations.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }

    /// Fetch all messages from all conversations using FirestoreMessage
    func fetchAllMessages() async {
        allMessages.removeAll() // Clear previous messages

        for conversation in conversations {
            let conversationId = conversation.id // No optional unwrapping needed

            do {
                let snapshot = try await db.collection("conversations")
                    .document(conversationId)
                    .collection("messages")
                    .order(by: "createdAt", descending: false)
                    .getDocuments()

                let messages = snapshot.documents.compactMap { doc -> Message? in
                    guard let firestoreMessage = try? doc.data(as: FirestoreMessage.self) else { return nil }
                    return firestoreMessage.toMessage(users: conversation.users)
                }

                DispatchQueue.main.async {
                    self.allMessages.append(contentsOf: messages)
                }
                print("✅ Fetched \(messages.count) messages for conversation \(conversationId)")

            } catch {
                print("❌ Error fetching messages for conversation \(conversationId): \(error)")
            }
        }
    }

    /// Search for a specific message by text
    func searchMessage(_ query: String) -> [Message] {
        return allMessages.filter { $0.text.lowercased().contains(query.lowercased()) }
    }

    func getData() {
        DataStorageService.shared.getData()
        Task {
            await fetchAllMessages() // Refresh messages when new data is fetched
        }
    }
}
