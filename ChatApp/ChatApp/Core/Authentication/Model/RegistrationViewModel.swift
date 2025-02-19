//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

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
    @Published var username: String = ""
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await loadImage()
            }
        }
    }
    
    @Published var profileImage: Image? = nil
    @Published var nickname = ""
    @Published var phone_number = ""
    @Published var date_of_birth = Date.now
    
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
    

    func registerPart1() async throws {
        do {
            try await AuthenticationService.shared.registerPart1(withEmail: email, username: username, password: password)
            registerError = nil // Clear error on successful register
        } catch let error as NSError {
            registerError = error.localizedDescription // Update error to show in UI
        }
    }

    func registerPart2() async throws {
        do {
            //logic fot image upload
            let data: [String: Any] = [
                "avatarURL": "",
                "nickname": self.nickname,
                "phone_number": self.phone_number,
                "date_of_birth": self.date_of_birth,
                "thread_id": ""  // Placeholder for AI thread
            ]
            try await AuthenticationService.shared.registerPart2(data: data)
            registerError = nil
            clearAuthFields()
            clearInfoFields()
        } catch let error as NSError {
            registerError = error.localizedDescription
        }
    }
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func clearAuthFields() {
        email = ""
        username = ""
        password = ""
        repeatedPassword = ""
    }
    
    func clearInfoFields() {
        profileImage = nil
        nickname = ""
        phone_number = ""
        date_of_birth = .now
    }
    
}
