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
    
    //Auth service doesnt log in properly
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    //when creating account info toggle
    @Published var newUser = false
    @AppStorage("email-link") var emailLink: String?
    
    static let authenticator = AuthenticationService()
    
    init() {
        Task {
            try await loadUserData()
        }
        print("User session id is \(userSession?.uid)")
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
            print("Logged in user with uid \(result.user.uid) successfully")
        } catch let error as NSError {
            print("Failed to log in user with error \(error.code)")
            throw mapFirebaseError(error)
        }
    }
    
    @MainActor
    func register(withEmail email: String, username: String, password: String) async throws {
        do {
            let isUnique = try await isUsernameUnique(username: username)
                   
            guard isUnique else {
                throw NSError(domain: "UserError", code: AuthErrorCode.accountExistsWithDifferentCredential.rawValue, userInfo: [NSLocalizedDescriptionKey: "Username already taken. Please choose another one."])
            }
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            try await uploadUserData(email: email, username: username, uid: result.user.uid)
            print("Created user with uid \(result.user.uid) successfully.")
        } catch let error as NSError {
            print("Failed to create user with error \(error.localizedDescription)")
            throw mapFirebaseError(error)
        }
    }
    
    // need finish
    func sendRegisterLink(withEmail email: String) async {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "https://mishoni.page.link/email-link-register")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        do {
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            print("Verification link sent to \(email)")
            emailLink = email // Save the email for later verification
        } catch {
            print("Failed to send verification link: \(error.localizedDescription)")
        }
    }

    func verifyEmailLink(_ link: String) async throws {
        guard let email = emailLink else { throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No email saved for verification."]) }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, link: link)
            if result.user.isEmailVerified {
                print("Email verified successfully for \(email)")
                try await loadUserData()
            } else {
                throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email verification failed."])
            }
        } catch {
            print("Failed to verify email: \(error.localizedDescription)")
            throw error
        }
    }

    func checkEmailVerification() async throws {
        guard let user = Auth.auth().currentUser else { throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in."]) }
        
        try await user.reload()
        if user.isEmailVerified {
            print("Email is verified.")
        } else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email is not verified. Please check your inbox."])
        }
    }
   
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("Logged out successfully!")
        } catch {
            print("Failed to sign out user with error \(error.localizedDescription)")
        }
    }
    
    
    func uploadUserData(email: String, username: String, uid: String) async throws {
//        let user = User(email: email, username: username)
//        self.currentUser = user
//        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
//        try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
    }
    
    func updateUserData(data: [String: Any]) async throws {
        try await Firestore.firestore().collection("users").document(userSession!.uid).updateData(data)
    }
    
    @MainActor
    func loadUserData() async throws {
//        self.userSession = Auth.auth().currentUser
//        guard let currentUID = userSession?.uid else { return }
//        let snapshot = try await Firestore.firestore().collection("users").document(currentUID).getDocument()
//        self.currentUser = try? snapshot.data(as: MyUser.self)
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
    
    func isUsernameUnique(username: String) async throws -> Bool {
        let snapshot = try await Firestore.firestore().collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        return snapshot.documents.isEmpty // true if username is unique
    }
}


