import SwiftUI

struct ProfileView: View {
    @State private var status: Bool = false
    @State private var showPictureEditAlert = false
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @Binding var isEditing: Bool
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy"
        return formatter.string(from: .now)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack {
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            showPictureEditAlert = true
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
                    .alert("Change Profile Picture", isPresented: $showPictureEditAlert) {
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
            }
            else{
                VStack(alignment: .leading, spacing: 12) {
                    Text("Username: username")
                    Text("Phone Number: +XXX XXXX XXXX")
                    Text("Date of Birth: \(formattedDate)")
                }
                .font(.body)
                .padding(.horizontal)
            }
            Spacer()
            
            Button("Log out"){
                AuthenticationService.authenticator.signOut()
            }
        }
        .padding()
        .navigationTitle("Your profile")
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
    ProfileView(isEditing: .constant(false))
}
