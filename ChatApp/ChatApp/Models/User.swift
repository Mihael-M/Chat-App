//
//  User.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable {
    @DocumentID var uid: String?
    let email: String
    let username: String
    
    var id: String {
        return uid ?? NSUUID().uuidString
    }
    
}

extension User {
    static var emptyUser: User {
        User(email: "user@example.com", username: "user")
    }
}
