//
//  Account.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct Account: Codable, Identifiable, Hashable {
    @DocumentID var uid: String?

    var nickname: String
    var phone_number: String
    var date_of_birth: Date
    var profilePictureURL: String? = nil
    var activityStatus: Bool
    var messagesSent: Int = 0
    var messagesReceived: Int = 0
    
    var id: String {
        return uid ?? NSUUID().uuidString
    }
}

extension Account {
    static var emptyAccount: Account {
        Account(nickname: "user_example",
                phone_number: "XXX XXX XXX",
                date_of_birth: .now,
                profilePictureURL: "picture",
                activityStatus: false)
    }
}
