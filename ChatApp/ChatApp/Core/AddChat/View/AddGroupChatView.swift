//
//  AddGroupChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI
import ExyteMediaPicker

struct AddGroupChatView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: AddChatViewModel
    @Binding var isPresented: Bool
    @Binding var navPath: NavigationPath
    @State private var isPressed: Bool = false
    @State private var showPicker = false
    @State private var avatarURL: URL?
    var body: some View {
        VStack {
            VStack {
                CustomTextField(icon: "magnifyingglass", prompt: "Search user...", value: $viewModel.searchableText)
                    .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
            }
            .padding()
            .padding(.horizontal, 16)
            
            pickImageView
                .padding(.top, 32)

            CustomTextField(icon: "person.3.fill", prompt: "Group name", value: $viewModel.title)
                .padding(.top, 32)

            List(viewModel.filteredUsers) { user in
                HStack {
                    ProfilePictureComponent(user: user, size: .small)
                    Text(user.base.name)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    (viewModel.selectedUsers.contains(user) ? Image(systemName: "circle.fill") : Image(systemName: "circle"))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if viewModel.selectedUsers.contains(user)
                    {
                        print("maham user")
                        viewModel.selectedUsers.removeAll(where: { $0.id == user.id })
                    }
                    else{
                        print("dobavqm user")

                        viewModel.selectedUsers.append(user)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .padding(.bottom, 60)
            
            Button{
                Task {
                    if let conversation = await viewModel.createConversation(viewModel.selectedUsers) {
                        viewModel.selectedUsers = []
                        isPresented = false
                        navPath.append(conversation)
                    }
                }
                
            }
            label:{
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width:60, height: 60)
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animation(.spring(), value: isPressed)
                    Image(systemName: "person.2.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Create Group")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
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
        .frame(width: 200, height: 200)
        .clipShape(Circle())
        .contentShape(Circle())
        .onTapGesture {
            showPicker = true
        }
    }
}

#Preview {
    //AddGroupChatView(selectedUser: .constant(MyUser.emptyUser))
}
