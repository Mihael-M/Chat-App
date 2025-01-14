//
//  AuthenticationViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

import SwiftUI
import Firebase
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    
    init() {
        checkLogInStatus()
    }
    
    func register(email: String, password: String, username: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else  { return }
            
            self.storeUserInFirestore(uid: uid, email: email, username: username) { error in
                if error == nil {
                    self.isLoggedIn = true
                    self.currentUser = User(uid: uid, email: email)
                }
                completion(error)
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                    completion(error)
                    return
            }
            self?.fetchUserFromFirestore(uid: result?.user.uid ?? "") { user, error in
                if let user = user {
                    self?.currentUser = user
                    self?.isLoggedIn = true
                }
                completion(error)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func checkLogInStatus() {
        if let uid = Auth.auth().currentUser?.uid {
            fetchUserFromFirestore(uid: uid) { user, error in
                if let user = user {
                    self.currentUser = user
                    self.isLoggedIn = true
                }
            }
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func storeUserInFirestore(uid: String, email: String, username: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "uid": uid,
            "email": email,
            "username": username
        ]
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.setData(data)
    }
    
    private func fetchUserFromFirestore(uid: String, completion: @escaping (User?, Error?) -> Void) {
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument { document, error in
            if let data = document?.data() {
                let user = User(uid: uid, email: data["email"] as? String ?? "")
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
