import SwiftUI

struct ProfileView: View {
    @State private var activityStatus: Bool = false
    @State private var profileImageURL: String = "picture"
    @Binding var isEditing: Bool
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy"
        return formatter.string(from: .now)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                ProfilePictureView(profileImageURL: $profileImageURL, activityStatus: $activityStatus)
                MessagesCountView()
                
            }
            VStack(alignment: .leading) {
                Text("username")
                    .font(.headline)
                Text("+XXX XXXX XXXX")
                Text("Date of Birth: \(formattedDate)")
            }
            .font(.subheadline)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .navigationTitle("Your profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    ProfileView(isEditing: .constant(false))
}
