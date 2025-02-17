import SwiftUI

struct AddChatView: View {
    @State private var searchText: String = ""
    @StateObject private var viewModel = AddChatViewModel()
    @Binding var selectedUser: MyUser?
    @State private var groupChat: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //groupchat logic
                
                VStack {
                    CustomTextField(icon: "magnifyingglass", prompt: "Search user...", value: $searchText)
                        .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
                }
                .padding()
                .padding(.horizontal, 16)
                
                Button {
                    groupChat.toggle()
                }
                label:{
                    HStack{
                        Image(systemName: "person.3.sequence.fill")
                        Text("Group Chat")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(20)
                    .foregroundStyle(.gray)
                }
                .navigationDestination(isPresented: $groupChat, destination: {AddGroupChatView()})
                
                ForEach(viewModel.users) { user in
                    VStack {
                        HStack {
                            ProfilePictureComponent(user: user, size: .small, showActivityStatus: true)
                            Text(user.base.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading, 32)
                    }
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add chat")
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
        AddChatView(selectedUser: .constant(MyUser.emptyUser))
    }
}
