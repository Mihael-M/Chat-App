import SwiftUI

struct AddChatView: View {
    @ObservedObject var dataStorage = DataStorageService.shared
    @StateObject private var viewModel = AddChatViewModel()
    
    @Binding var isPresented: Bool
    @Binding var navPath: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            //           ScrollView {
            //groupchat logic
            
            VStack {
                CustomTextField(icon: "magnifyingglass", prompt: "Search user...", value: $viewModel.searchableText)
                    .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
            }
            .padding()
            .padding(.horizontal, 16)
            
            List {
                NavigationLink {
                    AddGroupChatView(viewModel: viewModel, isPresented: $isPresented, navPath: $navPath)
                }
                label:{
                    HStack{
                        Image(systemName: "person.3.sequence.fill")
                        Text("Group Chat")
                        Spacer()
                        //Image(systemName: "chevron.right")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .padding(.top, 8)
                .padding(.horizontal, 16)
                
                Rectangle()
                    .foregroundColor(.black)
                    .frame(height: 1)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                
                ForEach(viewModel.filteredUsers) { user in
                    HStack {
                        ProfilePictureComponent(user: user, size: .small)
                        Text(user.base.name)
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding([.horizontal, .bottom], 16)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.selectedUsers.count == 0 {
                            viewModel.selectedUsers.append(user)
                           
                            Task{
                                if let conversation = await viewModel.conversationForUsers([user]) {
                                    navPath.append(conversation)
                                    viewModel.selectedUsers = []
                                    isPresented = false
                                } else if let conversation = await viewModel.createIndividualConversation(viewModel.selectedUsers) {
                                    viewModel.selectedUsers = []
                                    isPresented = false
                                    navPath.append(conversation)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("New message")
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
}

#Preview {
    NavigationStack {
        //AddChatView(selectedUser: .constant(MyUser.emptyUser))
    }
}
