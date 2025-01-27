//
//  EditView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI
import PhotosUI

struct EditProfileView : View {
    @StateObject var viewModel: EditProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    init(newUser: Bool = false, account: Account) {
        self._viewModel = StateObject(wrappedValue:     EditProfileViewModel(newUser: newUser, account: account))
    }
    
    var body: some View{
        VStack {
            PhotosPicker(selection: $viewModel.selectedImage) {
                if let image = viewModel.profileImage {
                    image
                        .resizable()
                        .frame(width:200, height: 200)
                        .scaledToFit()
                        .clipShape(Circle())
                } else {
                    Image("picture")
                        .resizable()
                        .frame(width:200, height: 200)
                        .scaledToFit()
                        .clipShape(Circle())
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {

                CustomTextField(icon: "person.fill", prompt: "Username", value: $viewModel.username)
                CustomTextField(icon: "hands.sparkles.fill", prompt: "Nickname", value: $viewModel.nickname)
                CustomTextField(icon: "phone.badge.plus.fill", prompt: "Phone number", value: $viewModel.phone_number)
                    .keyboardType(.numberPad)
                DatePicker("Date of Birth: ", selection: $viewModel.date_of_birth, displayedComponents: .date)
                    .datePickerStyle(.automatic)
                    .foregroundStyle(Color(.systemGray))
                
            }
            .font(.body)
            .padding()
            
        }
        Button {
            Task {
                try await viewModel.updateAccountData()
                dismiss()
            }
        } label:{
            Text("Save")
        }
        .padding()
    }
}


#Preview {
    let account = Account.emptyAccount
    EditProfileView(account: account)
}
