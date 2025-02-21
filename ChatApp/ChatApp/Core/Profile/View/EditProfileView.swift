//
//  EditView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI
import PhotosUI
import ExyteMediaPicker

struct EditProfileView: View {
    @StateObject var viewModel = EditProfileViewModel()
    
    @State private var isPressed: Bool = false
    @State private var showPicker = false
    //@State private var avatarURL: URL?
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer()
            //header
            VStack {
//                PhotosPicker(selection: $viewModel.selectedItem) {
//                    if let image = viewModel.profileImage {
//                        image
//                            .resizable()
//                            .frame(width:200, height: 200)
//                            .scaledToFit()
//                            .clipShape(Circle())
//                    } else {
//                        ProfilePictureComponent(user: MyUser.emptyUser, size: .xlarge)
//                    }
//                }
                
                    pickImageView
            }
            //fields
            VStack(alignment: .leading, spacing: 12) {

                CustomTextField(icon: "person.fill", prompt: "Nickname", value: $viewModel.nickname)
                Divider()
                CustomTextField(icon: "phone.fill", prompt: "Phone number", value: $viewModel.phone_number)
                    .keyboardType(.numberPad)
                HStack {
                    Image(systemName: viewModel.isValidPhoneNumber ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(viewModel.isValidPhoneNumber ? .green : .red)
                    Text("Enter valid phone number")
                        .font(.footnote)
                        .textSelection(.disabled)
                        .foregroundColor(viewModel.isValidPhoneNumber ? .green : .red)
                }
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
                    try await viewModel.updateCurrentUser()
                }
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
            .disabled(!viewModel.isValidPhoneNumber)
            .onTapGesture {
                isPressed.toggle()
            }
            Spacer()
        }
        .navigationTitle("Edit profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.systemGray))
                }
            }
        }
        .fullScreenCover(isPresented: $showPicker) {
            MediaPicker(isPresented: $showPicker) { media in
                viewModel.picture = media.first
//                Task {
//                    await avatarURL = viewModel.picture?.getURL()
//                }
            }
            .mediaSelectionLimit(1)
            .mediaSelectionType(.photo)
            .showLiveCameraCell()
        }
    }
    var pickImageView: some View {
        AsyncImage(url: viewModel.user.base.avatarURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ZStack {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.gray, lineWidth: 2)
        )
        .contentShape(Circle())
        .onTapGesture {
            showPicker = true
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
