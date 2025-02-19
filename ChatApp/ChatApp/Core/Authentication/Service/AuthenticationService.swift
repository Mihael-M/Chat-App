//
//  AuthenticationService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//
import SwiftUI
import Firebase
import FirebaseAuth
import Combine

class AuthenticationService {

    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthenticationService()
    
    init() {
           self.userSession = Auth.auth().currentUser
           print("User session id is \(userSession?.uid ?? "No user")")
           
           loadCurrentUserData()

           // ✅ Ensure AI user exists at startup
           Task {
               await DataStorageService.shared.ensureAIUserExists()
           }
       }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
            print("Logged in user with uid \(result.user.uid) successfully")
        } catch let error as NSError {
            print("Failed to log in user with error \(error.code)")
            throw mapFirebaseError(error)
        }
    }

    func registerPart1(withEmail email: String, username: String, password: String) async throws {
        do {
            try await isUsernameUnique(username: username)
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await uploadUserAuthData(email: email, username: username, uid: result.user.uid)
            loadCurrentUserData()
            print("Created user with uid \(Auth.auth().currentUser!.uid) successfully.")
        } catch let error as NSError {
            print("Failed to create user with error \(error.localizedDescription)")
            throw mapFirebaseError(error)
        }
    }
 
    func registerPart2(data: [String: Any]) async throws {
        do {
            try await Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(data)
            
            self.userSession = Auth.auth().currentUser
            
            print("Added info about user with uid \(userSession!.uid) successfully.")
        } catch let error as NSError {
            try await Auth.auth().currentUser?.delete()
            print("Failed to create user with error \(error.localizedDescription)")
            throw mapFirebaseError(error)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            DataStorageService.shared.reset()
            print("Logged out successfully!")
        } catch let error as NSError {
            print("Failed to sign out user with error \(error.localizedDescription)")
        }
    }
    
    func uploadUserAuthData(email: String, username: String, uid: String) async throws {
        let data: [String: Any] = [
            "uid": uid,
            "email": email,
            "username": username,
            "thread_id": ""  // Initialize thread_id (empty, will be assigned later)
        ]
        try await Firestore.firestore().collection("users").document(uid).setData(data, merge: true)
    }

    private func mapFirebaseError(_ error: NSError) -> Error {
            guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                return NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred. Please try again."])
            }
            
            switch errorCode {
            case .networkError:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "Network error. Please check your internet connection."])
            case .userNotFound:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "No user found with this email. Please sign up first."])
            case .invalidCredential:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "Incorrect password. Please try again."])
            case .invalidEmail:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "The email address is invalid. Please check and try again."])
            case .emailAlreadyInUse:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "This email is already in use. Please try logging in."])
            case .weakPassword:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "The password is too weak. Please use a stronger password."])
            case .accountExistsWithDifferentCredential:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "This username is already taken. Please choose another."])
            default:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred: \(error.localizedDescription)"])
            }
        }
    
    private func isUsernameUnique(username: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        if !snapshot.documents.isEmpty {
            throw NSError(domain: "UserError", code: AuthErrorCode.accountExistsWithDifferentCredential.rawValue, userInfo: [NSLocalizedDescriptionKey: "Username already taken. Please choose another one."])
        }
    }
    
    private func loadCurrentUserData() {
        Task {
            try await DataStorageService.shared.loadCurrentUserData()
        }
    }
}


