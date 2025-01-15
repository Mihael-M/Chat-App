//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import SwiftUI

class RegistrationViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func register() async throws{
        try await AuthenticationService().register(withEmail: email, password: password)
    }
}
