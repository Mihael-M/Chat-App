//
//  User.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI

struct UserModel: Codable, Identifiable, Hashable {
    var id = NSUUID().uuidString
    let email: String
    let account: Account
    
}

extension UserModel {
    static var emptyUser: UserModel {
        UserModel(email: "user@example.com",
             account: Account.emptyAccount)
    }
}
