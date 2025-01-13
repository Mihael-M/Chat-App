import SwiftUI

struct AddChatView: View {
    @State private var userID: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            
            CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $userID)
            
            Button(action: {}, label: {
                NavigationLink(destination: AddGroupChatView()) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .font(.title2)
                        
                        Text("Group chat")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.primary)
                }
            })
            if userManager.friends.isEmpty {
                Text("No users found")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                List(userManager.friends) { friend in
                    VStack {
                        Text(friend.currentAccount!.username.isEmpty ? "Unnamed User" : friend.currentAccount!.username)
                    }
                }
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
    }
}

#Preview {
    AddChatView()
        .environmentObject(UserManager())
}
