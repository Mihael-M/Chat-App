//
//  User.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 4.01.25.
//

import SwiftUI

class User: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var phone_number: String = ""
    @Published var date_of_birth: Date = .now
    @Published var active: Bool = true
    @Published var messagesSent: Int = 0
    @Published var messagesReceived: Int = 0
}
