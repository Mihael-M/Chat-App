////
////  ChatViewModel.swift
////  ChatApp
////
////  Created by Mishoni Mihaylov on 10.02.25.
////
//
//import SwiftUI
//import ExyteChat
//
//class ConversationViewModel: ObservableObject {
//    @Published var messages: [Message] = []
//    
//    
//    let currentUser: User
//
//    init() {
//        self.currentUser = User(id: "you", name: "You", avatarURL: nil, isCurrentUser: true)
//        let otherUser = User(id: "alice", name: "Alice", avatarURL: nil,isCurrentUser: false)
//        
//        self.messages = [
//            Message(id: "1", user: otherUser,
//                    createdAt: Date().addingTimeInterval(-60), text: "Hello!"),
//            Message(id: "2", user: otherUser,
//                    createdAt: Date().addingTimeInterval(-30), text: "How are you!"),
//            Message(id: "1", user: otherUser,
//                    createdAt: Date(), text: "I will be back!")
//        ]
//    }
//    
//    /// Appends a new message (using the current user as sender).
//    func sendMessage(_ draft: String) {
//        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty else { return }
//        
//        let newMessage = Message(
//            id: UUID().uuidString,
//            user: currentUser,
//            createdAt: Date(),
//            text: trimmed
//        )
//        messages.append(newMessage)
//    }
//    
//    /// Placeholder for resetting an unread counter.
//    func resetUnreadCounter() {
//        print("Reset unread counter")
//    }
//}
