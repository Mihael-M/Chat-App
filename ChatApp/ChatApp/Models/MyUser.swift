//
//  User.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI
import ExyteChat

struct MyUser : Hashable, Identifiable {
    let base: User //ExyteChat's model
    
    var id: String {
        base.id
    }
    var email: String
    var nickname: String
    var phone_number: String
    var date_of_birth: Date
    var activityStatus: Bool
    var messagesSent: Int = 0
    var messagesReceived: Int = 0
    
    var profilePicture: String {
        base.avatarURL?.absoluteString ?? "picture"
    }
    
    init(base: User, email: String, nickname: String, phone_number: String, date_of_birth: Date, activityStatus: Bool) {
        self.base = base
        self.email = email
        self.nickname = nickname
        self.phone_number = phone_number
        self.date_of_birth = date_of_birth
        self.activityStatus = activityStatus
    }
}

extension MyUser {
    static var emptyUser : MyUser {
        MyUser(base: User(id: "0", name: "user", avatarURL: nil, isCurrentUser: true), email: "user@example.com", nickname: "user", phone_number: "xxxxxxxxx", date_of_birth: .now, activityStatus: false)
    }
}
