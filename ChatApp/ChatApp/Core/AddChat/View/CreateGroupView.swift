//
//  GroupCreateView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 18.02.25.
//


import SwiftUI
import ExyteMediaPicker

struct CreateGroupView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: AddChatViewModel
    @Binding var isPresented: Bool
    @Binding var navPath: NavigationPath

    // private

    @State private var showPicker = false
    @State private var avatarURL: URL?

    @State private var showActivityIndicator = false

    var body: some View {
        VStack {
            pickImageView
                .padding(.top, 32)

            CustomTextField(icon: "person.3.fill", prompt: "Group name", value: $viewModel.title)
                .padding(.top, 32)

            Spacer()

            Button("Create") {
                Task {
                    showActivityIndicator = true
                    if let conversation = await viewModel.createConversation(viewModel.selectedUsers) {
                        showActivityIndicator = false
                        viewModel.selectedUsers = []
                        isPresented = false
                        navPath.append(conversation)
                    }
                }
            }
            .disabled(viewModel.title.isEmpty)
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 12)
        .navigationTitle("Create Group")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .fullScreenCover(isPresented: $showPicker) {
            MediaPicker(isPresented: $showPicker) { media in
                viewModel.picture = media.first
                Task {
                    await avatarURL = viewModel.picture?.getURL()
                }
            }
            .mediaSelectionLimit(1)
            .mediaSelectionType(.photo)
            .showLiveCameraCell()
        }
    }

    var pickImageView: some View {
        AsyncImage(url: avatarURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ZStack {
                Color(.systemGray)
                Image("defaultavatar")
            }
        }
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .contentShape(Circle())
        .onTapGesture {
            showPicker = true
        }
    }
}
