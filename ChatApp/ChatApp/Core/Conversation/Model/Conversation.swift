//
//  ChatModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//
import Foundation
import FirebaseFirestore

public struct Conversation: Identifiable, Hashable {
    public let id: String
    public let users: [MyUser]
    public let usersUnreadCountInfo: [String: Int]
    public let isGroup: Bool
    public let pictureURL: URL?
    public let title: String
    
    public var picture: String {
        pictureURL?.absoluteString ?? "defaultavatar"
    }

    public let latestMessage: LatestMessageInChat?

    init(id: String, users: [MyUser], usersUnreadCountInfo: [String: Int]? = nil, isGroup: Bool, pictureURL: URL? = nil, title: String = "", latestMessage: LatestMessageInChat? = nil) {
        self.id = id
        self.users = users
        self.usersUnreadCountInfo = usersUnreadCountInfo ?? Dictionary(uniqueKeysWithValues: users.map { ($0.id, 0) } )
        self.isGroup = isGroup
        self.pictureURL = pictureURL
        self.title = title
        self.latestMessage = latestMessage
    }

    var notMeUsers: [MyUser] {
        users.filter { $0.id != DataStorageService.currentUserID }
    }

    var displayTitle: String {
        if !isGroup, let user = notMeUsers.first {
            return user.base.name
        }
        return title
    }
}


public struct LatestMessageInChat: Hashable {
    public var senderName: String
    public var createdAt: Date?
    public var text: String?
    public var subtext: String?

    var isMyMessage: Bool {
        DataStorageService.shared.currentUser?.base.name == senderName
    }
}

public struct FirestoreConversation: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    public let users: [String]
    public let usersUnreadCountInfo: [String: Int]?
    public let isGroup: Bool
    public let pictureURL: String?
    public let title: String
    public let latestMessage: FirestoreMessage?
}
