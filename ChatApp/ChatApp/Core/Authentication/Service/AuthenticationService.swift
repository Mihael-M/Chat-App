//
//  AuthenticationService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import Firebase
import FirebaseAuth
import Combine

class AuthenticationService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let authenticator = AuthenticationService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        print("User session id is \(userSession?.uid)")
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("Logged in user with uid \(result.user.uid) successfully")
        } catch let error as NSError{
            print("Failed to log in user with error \(error.code)")
            throw mapFirebaseError(error)
        }
    }
    
    func register(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
//            self.userSession = result.user
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
            default:
                return NSError(domain: "AuthError", code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred: \(error.localizedDescription)"])
            }
        }
}


