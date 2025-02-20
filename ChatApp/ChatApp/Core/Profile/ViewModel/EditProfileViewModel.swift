//
//  EditProfileViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.01.25.
//

import SwiftUI
import PhotosUI
import ExyteMediaPicker

class EditProfileViewModel: ObservableObject {
//    @Published var selectedItem: PhotosPickerItem? {
//        didSet {
//            Task {
//                try await loadImage()
//            }
//        }
//    }
    
//    @Published var profileImage: Image?
    var user: MyUser {
        DataStorageService.shared.currentUser!
    }
    @Published var picture: Media?
    @Published var nickname = ""
    @Published var phone_number = ""
    {
        didSet{
            validatePhone_number()
        }
    }
    @Published var date_of_birth = Date.now
    @Published var isValidPhoneNumber: Bool = false
    private func validatePhone_number() {
        isValidPhoneNumber = validatePhoneNumber(phone_number)
    }
    private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^(?:\\+359|0)\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: phoneNumber)
        
    }
    init() {
        picture = nil
        nickname = user.nickname
        phone_number = user.phone_number
        date_of_birth = user.date_of_birth
    }
    
    func updateCurrentUser() async throws {
        let pictureURL = await UploadingService.uploadImageMedia(picture)
        
        var data: [String: Any] = [:]
        
        if nickname != user.nickname {
            data["nickname"] = nickname
        }
        if phone_number != user.phone_number {
            data["phone_number"] = phone_number
        }
        if date_of_birth != user.date_of_birth {
            data["date_of_birth"] = date_of_birth
        }
        if picture != nil {
            data["avatarURL"] = pictureURL?.absoluteString
        }
        if !data.isEmpty {
            try await DataStorageService.shared.updateCurrentUserData(data: data)
        }
    }
 
    
//    func loadImage() async throws {
//        guard let item = selectedItem else { return }
//        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
//        guard let uiImage = UIImage(data: data) else { return }
//        self.profileImage = Image(uiImage: uiImage)
//    }
}
