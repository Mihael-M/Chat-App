//
//  ChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

import SwiftUI
import ExyteChat
import FirebaseAuth

struct ChatView: View {
    @StateObject private var chatVM = ChatViewModel()
    let chatId: String
    @State private var inputText: String = ""

    var body: some View {
        VStack {
            
//            ExyteChatView(messages: chatVM.messages.map { message in
//                ChatMessage(
//                    user: message.isCurrentUser ? .myself : .other,
//                    text: message.text,
//                    timestamp: message.timestamp
//                )
//            })
//            .padding()

            HStack {
                TextField("Type a message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    chatVM.sendMessage(chatId: chatId, text: inputText)
                    inputText = ""
                }) {
                    Image(systemName: "paperplane.fill")
                }
                .padding()
            }
        }
        .onAppear {
            chatVM.fetchMessages(chatId: chatId)
        }
    }
}
