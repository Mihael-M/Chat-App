//
//  User.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 4.01.25.
//

import SwiftUI

struct User: Identifiable {
    var id: String { uid }
    var uid: String
    var email: String = ""
    var password: String = ""
    var currentAccount: Account?

    mutating func setAccount(account: Account) {
        self.currentAccount = account
    }
}


