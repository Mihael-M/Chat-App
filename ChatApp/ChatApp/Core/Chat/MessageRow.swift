////
////  MessageRow.swift
////  ChatApp
////
////  Created by Mishoni Mihaylov on 10.02.25.
////
//
//import SwiftUI
//import ExyteChat
//
//struct ChatMessageView: View {
//    let message: Message
//    let isCurrentUser: Bool
//
//    var body: some View {
//        HStack {
//            if isCurrentUser {
//                Spacer() // Push message to the right
//                Text(message.content)
//                    .padding(12)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(16)
//            } else {
//                Text(message.content)
//                    .padding(12)
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.black)
//                    .cornerRadius(16)
//                Spacer() // Push message to the left
//            }
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//    }
//}
//
//struct ChatMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            ChatMessageView(
//                message: Message(id: "1", content: "hello", senderUsername: "paci", receiverUsername: "koce", timestamp: Date()),
//                isCurrentUser: false
//            )
//            ChatMessageView(
//                message: Message(id: "2", content: "Bye", senderUsername: "koce", receiverUsername: "paci", timestamp: Date()),
//                isCurrentUser: true
//            )
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
