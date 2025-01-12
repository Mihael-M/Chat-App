//
//  ChatManager.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 12.01.25.
//

import Foundation


class ChatManager : ObservableObject{
    @Published var chats: [Chat] = []
    @Published var currentChat: Chat?
    
    func addChat(title: String, messages: [Message]) {
        let chat = Chat(title: title, messages: messages)
        chats.append(chat)
    }
    
    func enter(title: String) {
        if let chatIndex = chats.firstIndex(where: { $0.title == title}){
            currentChat = chats[chatIndex]
        }
    }
       
        func addMessage(role: String, message: String,date: Date,status:String) {
            let message = Message(role: role, text: message, date: date, status: status)
            currentChat?.messages.append(message)
        }
}



