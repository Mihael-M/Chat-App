////
////  MessageRow.swift
////  ChatApp
////
////  Created by Mishoni Mihaylov on 10.02.25.
////
//import SwiftUI
//import ExyteChat
//
//struct MessageView: View {
//    let message: Message
//    let isCurrentUser: Bool
//    
//    var body: some View {
//        HStack {
//            if isCurrentUser {
//                Spacer()
//                Text(message.text)
//                    .padding(12)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(16)
//            } else {
//                Text(message.text)
//                    .padding(12)
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.black)
//                    .cornerRadius(16)
//                Spacer()
//            }
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//    }
//}
//#Preview {
//    MessageView( message: Message(id: "1", user: User(id: "you", name: "You", avatarURL: nil, isCurrentUser: true),createdAt: Date(), text: "Hello!"), isCurrentUser: false)
//}
