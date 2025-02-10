//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchMessages(chatId: String) {
        listener = db.collection("chats").document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                
                self.messages = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                } ?? []
            }
    }

    func sendMessage(chatId: String, text: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let message = Message(text: text, senderId: userId, timestamp: Date())
        
        do {
            _ = try db.collection("chats").document(chatId)
                .collection("messages")
                .addDocument(from: message)
        } catch {
            print("Error sending message: \(error)")
        }
    }

    deinit {
        listener?.remove()
    }
}
