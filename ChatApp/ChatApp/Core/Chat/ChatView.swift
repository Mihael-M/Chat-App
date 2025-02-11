//
//  ChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import ExyteChat

struct ChatView: View {
    let chatId: String
        let usernames: [String]
        @State private var messages: [Message] = []
        @State private var newMessage: String = ""
        private let chatManager = ChatViewModel()

        var body: some View {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.senderUsername == "currentUsername" {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                } else {
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    fetchMessages()
                }

                HStack {
                    TextField("Type a message", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: sendMessage) {
                        Text("Send")
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding()
            }
            .navigationTitle(usernames.joined(separator: ", "))
        }

        private func fetchMessages() {
            chatManager.fetchMessages(for: chatId) { fetchedMessages in
                self.messages = fetchedMessages
            }
        }

        private func sendMessage() {
            let message = Message(content: newMessage, senderUsername: "currentUsername", receiverUsername: "otherUsername") // Replace with actual usernames
            chatManager.sendMessage(chatId: chatId, message: message) { success in
                if success {
                    fetchMessages()
                    newMessage = ""
                }
            }
        }
}
