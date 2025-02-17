//
//  RegisterInfoView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//

import SwiftUI
import PhotosUI

struct RegisterInfoView: View {
    @EnvironmentObject var viewModel : RegistrationViewModel
    
    @State private var isPressed: Bool = false
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            PhotosPicker(selection: $viewModel.selectedItem) {
                if let image = viewModel.profileImage {
                    image
                        .resizable()
                        .frame(width:200, height: 200)
                        .scaledToFit()
                        .clipShape(Circle())
                } else {
                    ProfilePictureComponent(user: MyUser.emptyUser, size: .xlarge)
                }
            }
            
            //fields
            VStack(alignment: .leading, spacing: 12) {
                
                CustomTextField(icon: "person.fill", prompt: "Nickname", value: $viewModel.nickname)
                Divider()
                CustomTextField(icon: "phone.fill", prompt: "Phone number", value: $viewModel.phone_number)
                    .keyboardType(.numberPad)
                Divider()
                HStack(spacing: 15) {
                    Image(systemName: "birthday.cake.fill")
                    DatePicker("Date of Birth: ", selection: $viewModel.date_of_birth, displayedComponents: .date)
                        .datePickerStyle(.automatic)
                        .foregroundStyle(Color(.systemGray))
                }
                .foregroundStyle(Color(.systemGray))
                
            }
            .font(.body)
            .padding()
            //save button
            Button {
                Task {
                    try await viewModel.registerPart2()
                    if viewModel.registerError != nil {
                        showErrorAlert.toggle()
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width:60, height: 60)
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animation(.spring(), value: isPressed)
                    Image(systemName: "checkmark")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
            .onTapGesture {
                isPressed.toggle()
            }
            Spacer()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error!"),
                message: Text((viewModel.registerError?.description)!),
                dismissButton: .default(Text("Try again"), action: {viewModel.clearInfoFields()})
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RegisterInfoView()
}
