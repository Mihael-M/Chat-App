//
//  User.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI
import ExyteChat
import FirebaseCore

public struct MyUser : Hashable, Identifiable, Codable {
    let base: User //ExyteChat's model
    
    public var id: String {
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
        base.avatarURL?.absoluteString ?? "defaultavatar"
    }
    
    init(base: User, email: String, nickname: String, phone_number: String, date_of_birth: Date, activityStatus: Bool) {
        self.base = base
        self.email = email
        self.nickname = nickname
        self.phone_number = phone_number
        self.date_of_birth = date_of_birth
        self.activityStatus = activityStatus
    }
    
    init?(dictionary: [String: Any], isCurrentUser: Bool) {
        // Unwrap required string values
        guard let uid = dictionary["uid"] as? String,
              let username = dictionary["username"] as? String,
              let email = dictionary["email"] as? String,
              let nickname = dictionary["nickname"] as? String,
              let dateTimestamp = dictionary["date_of_birth"] as? Timestamp,
              let phone_number = dictionary["phone_number"] as? String
        else {
            return nil
        }
        //avatar is optional
        if let avatarString = dictionary["avatarURL"] as? String {
            self.base = User(id: uid, name: username, avatarURL: URL(string: avatarString), isCurrentUser: isCurrentUser)
        } else {
            self.base = User(id: uid, name: username, avatarURL: nil, isCurrentUser: isCurrentUser)
        }
        self.email = email
        self.nickname = nickname
        self.date_of_birth = dateTimestamp.dateValue()
        self.phone_number = phone_number
        self.activityStatus = dictionary["activityStatus"] as? Bool ?? false
    }
}

extension MyUser {
    static var emptyUser : MyUser {
        MyUser(base: User(id: "0", name: "user", avatarURL: URL(string: "defaultavatar"), isCurrentUser: true), email: "user@example.com", nickname: "user", phone_number: "xxxxxxxxx", date_of_birth: .now, activityStatus: false)
    }
}
extension MyUser {
    static var aiUser: MyUser {
        MyUser(
            base: User(id: "AI_Bot", name: "AI Assistant", avatarURL: nil, isCurrentUser: false),
            email: "ai@assistant.com",
            nickname: "AI Assistant",
            phone_number: "N/A",
            date_of_birth: Date.distantPast,
            activityStatus: true
        )
    }
}
