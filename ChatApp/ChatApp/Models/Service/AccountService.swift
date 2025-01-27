//
//  AccountService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.01.25.
//

import SwiftUI
import PhotosUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class AccountService {
    @Published var userSession: FirebaseAuth.User?
    @Published var account: Account?
    
    static let accountService = AccountService()
    
    init() {
        Task {
            try await loadAccountData()
        }
        print("User session id is \(userSession?.uid)")
    }
    
    func uploadAccountData(data: [String: Any]) async throws {
        try await Firestore.firestore().collection("accounts").document(userSession!.uid).setData(data)
        AuthenticationService.authenticator.newUser = false
        print("New user with id \(userSession?.uid) is saved")
    }
    
    func updateAccountData(data: [String: Any]) async throws {
        try await Firestore.firestore().collection("accounts").document(userSession!.uid).updateData(data)
    }
    
    func loadAccountData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUID = userSession?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("accounts").document(currentUID).getDocument()
        self.account = try? snapshot.data(as: Account.self)
    }
}
