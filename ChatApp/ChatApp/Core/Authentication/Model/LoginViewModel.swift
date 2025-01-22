//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginError: String? = nil
    
    func login() async throws{
        do {
            try await AuthenticationService.authenticator.login(withEmail: email, password: password)
            loginError = nil // Clear error on successful login
        } catch let error as NSError {
            loginError = error.localizedDescription // Update error to show in UI
        }
    }
}
