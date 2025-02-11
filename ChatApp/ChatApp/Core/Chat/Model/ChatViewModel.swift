//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

import FirebaseFirestore
import FirebaseAuth

class ChatViewModel: ObservableObject {
    private let db = Firestore.firestore()

      // Fetch all chats for a user
      func fetchChats(for username: String, completion: @escaping ([Chat]) -> Void) {
          db.collection("chats").whereField("usernames", arrayContains: username).order(by: "lastUpdated", descending: true)
              .getDocuments { (snapshot, error) in
                  guard let documents = snapshot?.documents, error == nil else {
                      completion([])
                      return
                  }
                  let chats = documents.compactMap { doc in
                      Chat(from: doc.data(), id: doc.documentID)
                  }
                  completion(chats)
              }
      }

      // Fetch messages for a chat
      func fetchMessages(for chatId: String, completion: @escaping ([Message]) -> Void) {
          db.collection("chats").document(chatId).collection("messages").order(by: "timestamp")
              .getDocuments { (snapshot, error) in
                  guard let documents = snapshot?.documents, error == nil else {
                      completion([])
                      return
                  }
                  let messages = documents.compactMap { doc in
                      Message(from: doc.data(), id: doc.documentID)
                  }
                  completion(messages)
              }
      }

      // Send a message
      func sendMessage(chatId: String, message: Message, completion: @escaping (Bool) -> Void) {
          let chatRef = db.collection("chats").document(chatId)
          chatRef.collection("messages").addDocument(data: message.toDict()) { error in
              if let error = error {
                  print("Failed to send message: \(error)")
                  completion(false)
                  return
              }
              chatRef.updateData(["lastMessage": message.content, "lastUpdated": FieldValue.serverTimestamp()]) { error in
                  if let error = error {
                      print("Failed to update chat: \(error)")
                      completion(false)
                  } else {
                      completion(true)
                  }
              }
          }
      }
}
