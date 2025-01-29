//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import SwiftUI
import FirebaseAuth

class RegistrationViewModel : ObservableObject {
    @Published var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    @Published var password: String = "" {
        didSet {
            validatePassword()
        }
    }
    @Published var repeatedPassword: String = "" {
        didSet {
            validatePassword()
        }
    }
    
    @Published var isEmailValid: Bool = false
    @Published var isPasswordLengthValid: Bool = false
    @Published var containsUppercase: Bool = false
    @Published var containsNumber: Bool = false
    @Published var passwordMatches: Bool = false
    @Published var emailVerified: Bool = false
    @Published var registerError: String? = nil
    @Published var isEmailVerified: Bool = false
    private func validateEmail() {
        isEmailValid = isValidEmail(email)
    }
    
    private func validatePassword() {
        isPasswordLengthValid = password.count >= 8
        containsUppercase = password.contains(where: { $0.isUppercase })
        containsNumber = password.contains(where: { $0.isNumber })
        passwordMatches = (password == repeatedPassword) && !password.isEmpty
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func register() async throws {
        do {
            AuthenticationService.authenticator.newUser = true
            try await AuthenticationService.authenticator.register(withEmail: email, password: password)
            registerError = nil // Clear error on successful register
        } catch let error as NSError {
            registerError = error.localizedDescription // Update error to show in UI
        }
    }
    

    func sendVerificationEmail() async {
        do {
            try await AuthenticationService.authenticator.sendRegisterLink(withEmail: email)
        } catch {
            registerError = "Failed to send verification email. \(error.localizedDescription)"
        }
    }

    func verifyEmail(link: String) async {
        do {
            try await AuthenticationService.authenticator.verifyEmailLink(link)
            isEmailVerified = true
        } catch {
            registerError = "Failed to verify email. \(error.localizedDescription)"
        }
    }

    func checkEmailVerifiedStatus() async {
        do {
            try await AuthenticationService.authenticator.checkEmailVerification()
            isEmailVerified = true
        } catch {
            registerError = "Email is not verified. \(error.localizedDescription)"
        }
    }
    
    func verifyEmail() async throws {
        guard let link = AuthenticationService.authenticator.emailLink else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid or missing email verification link."])
        }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, link: link)
            self.emailVerified = result.user.isEmailVerified
            if emailVerified {
                AuthenticationService.authenticator.emailLink = nil // Clear the stored link
            }
        } catch let error as NSError {
            print("Error verifying email: \(error.localizedDescription)")
        }
    }
    
                                         
    
    func clearFields() {
        email = ""
        password = ""
        repeatedPassword = ""
    }
    
}
