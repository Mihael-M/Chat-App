import SwiftUI

struct ProfileHeaderView: View {
    @State private var activityStatus: Bool = false
    @State private var profileImageURL: String = "picture"
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy"
        return formatter.string(from: .now)
    }
    
    var body: some View {
        VStack() {
            
            VStack(spacing: 10) {
                //pic and stats
                HStack {
                    ProfilePictureComponent(profileImageURL: $profileImageURL, activityStatus: $activityStatus)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        MessagesStatView(value: 0, title: "Sent messages")
                        
                        MessagesStatView(value: 0, title: "Received messages")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                //user info
                VStack(alignment: .leading, spacing: 4) {
                    Text("username")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("+XXX XXXX XXXX")
                        .font(.footnote)
                    Text("Birthday: \(formattedDate)")
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                
            }
            
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileHeaderView()
}
