//
//  ChatModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//
import Foundation
import FirebaseFirestore

struct Chat: Identifiable {
    var id: String?
    var usernames: [String] // Usernames of participants
    var lastMessage: String?
    var lastUpdated: Date?

    init(id: String? = nil, usernames: [String], lastMessage: String? = nil, lastUpdated: Date? = nil) {
        self.id = id
        self.usernames = usernames
        self.lastMessage = lastMessage
        self.lastUpdated = lastUpdated
    }

    init?(from data: [String: Any], id: String) {
        guard let usernames = data["usernames"] as? [String],
              let lastUpdated = (data["lastUpdated"] as? Timestamp)?.dateValue() else {
            return nil
        }
        self.id = id
        self.usernames = usernames
        self.lastMessage = data["lastMessage"] as? String
        self.lastUpdated = lastUpdated
    }

    func toDict() -> [String: Any] {
        return [
            "usernames": usernames,
            "lastMessage": lastMessage ?? "",
            "lastUpdated": lastUpdated ?? Date()
        ]
    }
}
