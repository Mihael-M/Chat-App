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
    @Published var conversations: [Conversation] = [] // Stores all conversations
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
    //messages send
    var myMessageCount: Int {
        return allMessages.filter({$0.user.id == currentUser?.id}).count
    }
    //messages recieved
    var otherMessageCount: Int {
        return allMessages.filter({$0.user.id != currentUser?.id}).count
        
    }
    /// Fetch all messages from all conversations using FirestoreMessage
    func fetchAllMessages() async {
        var fetchedMessages: [Message] = [] // Temporary storage

        do {
            try await withThrowingTaskGroup(of: [Message].self) { group in
                for conversation in conversations {
                    group.addTask {
                        let conversationId = conversation.id

                        let snapshot = try await self.db.collection("conversations")
                            .document(conversationId)
                            .collection("messages")
                            .order(by: "createdAt", descending: false)
                            .getDocuments()

                        return snapshot.documents.compactMap { doc -> Message? in
                            guard let firestoreMessage = try? doc.data(as: FirestoreMessage.self) else { return nil }
                            return firestoreMessage.toMessage(users: conversation.users)
                        }
                    }
                }

                for try await messages in group {
                    fetchedMessages.append(contentsOf: messages)
                }
            }

            DispatchQueue.main.async {
                self.allMessages = fetchedMessages // Update all messages at once
            }

            try await updateMessageCount()
            print("✅ Count updated successfully")

        } catch {
            print("❌ Error fetching messages: \(error)")
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
    func updateMessageCount() async throws {
        if currentUser != nil {
            try await DataStorageService.shared.updateCurrentUserData(data: ["messagesSent": self.myMessageCount, "messagesReceived": self.otherMessageCount])
        }
    }
}
