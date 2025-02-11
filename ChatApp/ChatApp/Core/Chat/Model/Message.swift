//
//  Message.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

// MARK: - Messages

import Foundation
import FirebaseFirestore

struct Message: Identifiable {
    var id: String?
    var content: String
    var senderUsername: String
    var receiverUsername: String
    var timestamp: Date

    init(id: String? = nil, content: String, senderUsername: String, receiverUsername: String, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.senderUsername = senderUsername
        self.receiverUsername = receiverUsername
        self.timestamp = timestamp
    }

    init?(from data: [String: Any], id: String) {
        guard let content = data["content"] as? String,
              let senderUsername = data["senderUsername"] as? String,
              let receiverUsername = data["receiverUsername"] as? String,
              let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
            return nil
        }
        self.id = id
        self.content = content
        self.senderUsername = senderUsername
        self.receiverUsername = receiverUsername
        self.timestamp = timestamp
    }

    func toDict() -> [String: Any] {
        return [
            "content": content,
            "senderUsername": senderUsername,
            "receiverUsername": receiverUsername,
            "timestamp": timestamp
        ]
    }
}

