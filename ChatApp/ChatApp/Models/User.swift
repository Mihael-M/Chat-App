//
//  User.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI
import FirebaseFirestore

public struct User: Codable, Identifiable, Hashable {
    @DocumentID var uid: String?
    public let email: String
    public let username: String
    
   public var id: String {
        return uid ?? NSUUID().uuidString
    }
    
}

extension User {
    static var emptyUser: User {
        User(email: "user@example.com", username: "user")
    }
}
