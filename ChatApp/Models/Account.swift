//
//  Account.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import Foundation

struct Account: Identifiable{
    let id = UUID()
    var username: String = ""
    var phone_number: String = ""
    var date_of_birth: Date = .now
    var active: Bool = true
    var messagesSent: Int = 0
    var messagesReceived: Int = 0
}
