//
//  Chat.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 12.01.25.
//

import Foundation


struct Chat : Identifiable,Hashable{
    let id = UUID()
    var title: String
    var messages: [Message]
}





    

