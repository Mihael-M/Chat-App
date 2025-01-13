//
//  User.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 4.01.25.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    var email: String = ""
    var password: String = ""
    var currentAccount: Account?

    mutating func setAccount(account: Account) {
        self.currentAccount = account
    }
}


