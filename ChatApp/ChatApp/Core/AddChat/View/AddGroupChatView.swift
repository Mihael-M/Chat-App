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
    @State var navigate: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                CustomTextField(icon: "magnifyingglass", prompt: "Search user...", value: $viewModel.searchableText)
                    .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
            }
            .padding()
            .padding(.horizontal, 16)
            
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
            
            Button(action: {
                navigate.toggle()
            }, label: {Text("Next")})
            .disabled(viewModel.selectedUsers.count < 1)
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .listStyle(.plain)
        .navigationTitle("Create Group")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigate, destination: {CreateGroupView(viewModel: viewModel, isPresented: $isPresented, navPath: $navPath)})
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
    }
}

#Preview {
    //AddGroupChatView(selectedUser: .constant(MyUser.emptyUser))
}
