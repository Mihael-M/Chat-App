//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import SwiftUI

class LoginViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func login() async throws{
        try await AuthenticationService().login(withEmail: email, password: password)
    }
}
