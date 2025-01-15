import SwiftUI



//                                  Main view code ->
 
struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var chatManager: ChatManager
    @State private var status: Bool = false
    @State private var showAlert = false
    @State private var showRegisterAlert = false
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @Binding var isEditing: Bool
    @Binding var newUser: Bool
    private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d/MM/yyyy"
        return formatter.string(from: userManager.currentUser?.currentAccount?.date_of_birth ?? .now)
        }
 
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if newUser {
                RegisterView()
                    .environmentObject(userManager)
                    .environmentObject(chatManager)
            }
            else{
                HStack {
                    HStack {
                        ZStack(alignment: .topTrailing) {
                            Button(action: {
                                showAlert = true
                            }) {
                                profileImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 2)
                                    )
                                    .foregroundStyle(Color.secondary)
                                    .padding()
                            }
                            Button(action: {
                                // Handle status change here
                            }) {
                                Image(systemName: "bubble")
                                    .resizable()
                                    .foregroundStyle(status ? Color.green : Color.red)
                                    .frame(width: 24, height: 24)
                                
                            }
                        }
                        .alert("Change Profile Picture", isPresented: $showAlert) {
                            Button("Choose from Library") {
                                // choose from library...
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Would you like to change your profile picture?")
                        }
                    }
                    Spacer()
                    VStack {
                        Text("0")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Sent Messages")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Text("0")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Received Messages")
                            .font(.caption)
                    }
                    
                }
                .padding(.vertical)
                
                
                Divider()
                if isEditing {
                    EditView(isEditing: $isEditing)
                        .environmentObject(userManager)
                        .environmentObject(chatManager)
                }
                else{
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Username: \(userManager.currentUser?.currentAccount?.username ?? "")")
                        Text("Number: \(userManager.currentUser?.currentAccount?.phone_number ?? "")")
                        Text("Date of Birth: \(formattedDate)")
                    }
                    .font(.body)
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Nickname")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isEditing{
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Image(systemName: "pencil.line")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                }
               
               
            }
        }
            
    }
        
}

#Preview {
    ProfileView(isEditing: .constant(false),newUser: .constant(false))
        .environmentObject(UserManager())
        .environmentObject(ChatManager())
}
