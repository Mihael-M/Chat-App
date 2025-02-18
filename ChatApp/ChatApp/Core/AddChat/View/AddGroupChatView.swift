//
//  AddGroupChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct AddGroupChatView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: AddChatViewModel
    @Binding var isPresented: Bool
    @Binding var navPath: NavigationPath

    var body: some View {
        VStack {
            CustomTextField(icon: "person.3.fill", prompt: "Search here...", value: $viewModel.searchableText)
                .padding(.horizontal, 16)

            ZStack(alignment: .bottom) {
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
                        viewModel.selectedUsers.contains(user) ?
                        viewModel.selectedUsers.removeAll(where: { $0.id == user.id }) :
                        viewModel.selectedUsers.append(user)
                    }
                    .listRowSeparator(.hidden)
                }
                .padding(.bottom, 60)

                NavigationLink("Next") {
                    CreateGroupView(viewModel: viewModel, isPresented: $isPresented, navPath: $navPath)
                }
                .disabled(viewModel.selectedUsers.count < 1)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Create Group")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    Image("chevron.left")
                }
            }
        }
    }
}

#Preview {
    //AddGroupChatView(selectedUser: .constant(MyUser.emptyUser))
}
