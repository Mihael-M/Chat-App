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
    
    //    func addChat(title: String, messages: [Message]) {
    //        let chat = Chat(title: title, messages: messages)
    //        chats.append(chat)
    //    }    
}



