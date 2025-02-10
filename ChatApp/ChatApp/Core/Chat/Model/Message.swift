//
//  Message.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var senderId: String
    var timestamp: Date
    
    var isCurrentUser: Bool {
        return senderId == FirebaseAuth.Auth.auth().currentUser?.uid
    }
}
