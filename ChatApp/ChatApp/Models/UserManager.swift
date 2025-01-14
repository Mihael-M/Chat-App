//
//  UserManager.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import Foundation

class UserManager : ObservableObject {
    @Published var friends: [User] = []
    @Published var currentUser: User?
    
    // function for adding a user to the manager
    func enter(email: String,password:String) -> Bool{
            if let userIndex = friends.firstIndex(where: { $0.email == email && $0.password == password}){
                currentUser = friends[userIndex]
                return true
            }
        return false
    }
    func addUser(friend: User) {
        friends.append(friend)
    }
}
