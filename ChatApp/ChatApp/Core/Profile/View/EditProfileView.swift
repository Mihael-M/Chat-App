//
//  EditView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @StateObject var viewModel = EditProfileViewModel()
    
    @State private var isPressed: Bool = false
    
    let user : MyUser
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer()
            //header
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let image = viewModel.profileImage {
                        image
                            .resizable()
                            .frame(width:200, height: 200)
                            .scaledToFit()
                            .clipShape(Circle())
                    } else {
                        ProfilePictureComponent(pictureURL: MyUser.emptyUser.profilePicture, size: .large)
                    }
                }
                Text("Username")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical)
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
                print("save info")
                dismiss()
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
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.black))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: MyUser.emptyUser)
    }
}
