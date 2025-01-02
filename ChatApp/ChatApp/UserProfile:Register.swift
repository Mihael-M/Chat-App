import SwiftUI

struct ProfileView: View {
    // Трябва всички тези имена,имейли и т.н. да се прехвърлят в един общ обект user и да се пренапише...
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var messagesSent: Int = 0
    @State private var messagesReceived: Int = 0
    @State private var showAlert = false
    @State private var showRegisterAlert = false
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @Binding var isEditing: Bool
    @Binding var newUser: Bool
    
    private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d/MM/yyyy"
            return formatter.string(from: dateOfBirth)
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                                .foregroundStyle(Color.secondary)
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
                    Text("\(messagesSent)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Sent Messages")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("\(messagesReceived)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Received Messages")
                        .font(.caption)
                }
               
            }
            .padding(.vertical)
           

            Divider()
            if isEditing {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Enter username:",text: $username)
                    TextField("Enter email: \(email)",text: $email)
                    TextField("Enter number: \(number)",text:$number)
                    DatePicker("Date of Birth:", selection: $dateOfBirth, displayedComponents: .date)
                                           .datePickerStyle(GraphicalDatePickerStyle())
                }
                .font(.body)
                .padding(.horizontal)
                if newUser{
                    Button{
                        isEditing.toggle()
                        showRegisterAlert = true;
                    }
                    label:{
                        Text("Register")
                    }
                    .padding()
                    .alert("Profile Created", isPresented: $showRegisterAlert) {
                        Button("Great", role: .cancel) {}
                    } message: {
                        Text("Welcome to 'our app' \(username)!")
                    }
                }
                else {
                    Button{
                        isEditing.toggle()
                    }
                    label:{
                        Text("Save")
                    }
                    .padding()
                }
                
            }
            else{
                VStack(alignment: .leading, spacing: 12) {
                    Text("Username: \(username)")
                    Text("Email: \(email)")
                    Text("Number: \(number)")
                    Text("Date of Birth: \(formattedDate)")
                }
                .font(.body)
                .padding(.horizontal)
            }
            Spacer()
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
    ProfileView(isEditing: .constant(true),newUser: .constant(true))
}
