//
//  AuthenticationService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import Firebase
import FirebaseAuth

class AuthenticationService {
    
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        print("User session id is \(userSession?.uid)")
    }
    
    func login(withEmail email: String, password: String) async throws {
        print("Email is \(email)")
        print("Password is \(password)")
    }
    
    func register(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("Created user with uid \(result.user.uid) successfully.")
        } catch {
            print("Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            print("Logged out successfully!")
        } catch {
            print("Failed to sign out user with error \(error.localizedDescription)")
        }
    }
    
}
