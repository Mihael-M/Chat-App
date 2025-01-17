//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import SwiftUI

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
    
    @Published var isEmailValid: Bool = false
    @Published var isPasswordLengthValid: Bool = false
    @Published var containsUppercase: Bool = false
    @Published var containsNumber: Bool = false
    
    private func validateEmail() {
        isEmailValid = isValidEmail(email)
    }
    
    private func validatePassword() {
        isPasswordLengthValid = password.count >= 8
        containsUppercase = password.contains(where: { $0.isUppercase })
        containsNumber = password.contains(where: { $0.isNumber })
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func register() async throws {
        try await AuthenticationService.authenticator.register(withEmail: email, password: password)
    }
    
    func verifyEmail() async throws {
        try await AuthenticationService.authenticator.sendRegisterLink(withEmail: email)
    }
    
}
