//
//  ChatModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//
import Foundation
import FirebaseFirestore

struct Conversation {
    var isGroup: Bool
    var pictureURL: String? 
    var title: String
}
