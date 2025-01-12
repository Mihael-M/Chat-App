import SwiftUI
struct NewUser : View{
    @ObservedObject var user: User
    func isDisabled() -> Bool{
        user.email.isEmpty || user.password.isEmpty || user.password.count < 8 || user.email.contains("@") == false || user.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || user.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    @Binding var newUser: Bool
    @State private var showRegisterAlert = false
    @State private var isPressed = false
    var body: some View{
        NavigationStack{
            
            
            VStack(spacing: 30){
                VStack(alignment: .leading, spacing: 20) {
                    
                    CustomTextField(icon: "at", prompt: "Email", value: $user.email)
                    Text("Must be valid email")
                        .font(.footnote)
                        .foregroundStyle(.red)
                    CustomTextField(icon: "key", prompt: "Password", value: $user.password)
                    Text("Must be at least 8 characters")
                        .font(.footnote)
                        .foregroundStyle(.red)
                    
                    
                }
                .font(.body)
                .padding(.horizontal)
                HStack(spacing : 20)
                {
                    Button(action:{
                    })
                    {
                        NavigationLink("Already have an account", destination: LogInView(user: user))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .scaleEffect(isPressed ? 0.98 : 1.0)
                            .animation(.spring(), value: isPressed)
                    }
                    .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                        isPressed = pressing
                    }, perform: {})
                    
                    
                    Button(action:{
                        showRegisterAlert = true
                    })
                    {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .scaleEffect(isPressed ? 0.98 : 1.0)
                            .animation(.spring(), value: isPressed)
                    }
                    .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                        isPressed = pressing
                    }, perform: {})
                    .disabled(isDisabled())
                    
                }
            }
            .alert("Profile Created!", isPresented: $showRegisterAlert) {
                Button("Continue", role: .cancel) {newUser = false}
            } message: {
                Text("Set up your profile")
            }
        }
            
    }
    
}
struct ProfileEdit : View{
    @ObservedObject var user: User
    @Binding var isEditing: Bool
    var body: some View{
        VStack(alignment: .leading, spacing: 12) {
            CustomTextField(icon: "person.fill", prompt: "Username", value: $user.username)
            CustomTextField(icon: "phone.badge.plus.fill", prompt: "Phone", value: $user.phone_number)
                .keyboardType(.numberPad)
            DatePicker("Date of Birth:", selection: $user.date_of_birth, displayedComponents: .date)
                .datePickerStyle(.automatic)
                                   
        }
        .font(.body)
        .padding(.horizontal)
        
        Button{
            isEditing.toggle()
        }
        label:{
            Text("Save")
        }
        .padding()
    }
    
}

//                                  Main view code ->
 
struct ProfileView: View {
    @ObservedObject var user: User
    @State private var showAlert = false
    @State private var showRegisterAlert = false
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @Binding var isEditing: Bool
    @Binding var newUser: Bool
    
    private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d/MM/yyyy"
            return formatter.string(from: user.date_of_birth)
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if newUser {
                NewUser(user: user, newUser: $newUser)
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
                                    .foregroundStyle(user.active ? Color.green : Color.red)
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
                        Text("\(user.messagesSent)")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Sent Messages")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Text("\(user.messagesReceived)")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Received Messages")
                            .font(.caption)
                    }
                    
                }
                .padding(.vertical)
                
                
                Divider()
                if isEditing {
                    ProfileEdit(user: user, isEditing: $isEditing)
                }
                else{
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Username: \(user.username)")
                        Text("Email: \(user.email)")
                        Text("Number: \(user.phone_number)")
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
    ProfileView(user: User(),isEditing: .constant(false),newUser: .constant(false))
}
