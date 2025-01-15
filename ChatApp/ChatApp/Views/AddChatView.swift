import SwiftUI

struct AddChatView: View {
    @State private var userID: String = ""
    @Environment(\.dismiss) private var dismiss
    //@EnvironmentObject var userManager: UserManager
    @State private var groupChat: Bool = false
    var body: some View {
        NavigationStack{
                VStack(alignment: .center, spacing: 30) {
                    
                    RoundedRectangle(cornerRadius: 3)
                                      .frame(width: 40, height: 5)
                                      .foregroundColor(.gray.opacity(0.5))
                                      .padding(.top, 8)
                    CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $userID)
                    
                    Button
                    {
                        groupChat.toggle()
                    }
                    label: {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .font(.title2)
                            
                            Text("Group chat")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.primary)
                        
                    }
//                    if userManager.friends.isEmpty {
//                        Text("No users found")
//                            .font(.callout)
//                            .foregroundColor(.gray)
//                            .padding()
//                        Spacer()
//                    } else {
//                        List(userManager.friends) { friend in
//                            VStack {
//                                Text(friend.currentAccount!.username.isEmpty ? "Unnamed User" : friend.currentAccount!.username)
//                            }
//                        }
//                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 15)
                .sheet(isPresented: $groupChat, content: {
                    AddGroupChatView()
                        //.environmentObject(userManager)
                        .presentationDetents([.height(500)])
                })
        }
    }
}

#Preview {
    AddChatView()
        .environmentObject(UserManager())
}
