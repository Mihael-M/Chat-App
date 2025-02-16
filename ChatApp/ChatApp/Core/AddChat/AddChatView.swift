import SwiftUI

struct AddChatView: View {
    @State private var searchText: String = ""
    
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
                
                ForEach(0...10, id: \.self) { user in
                    VStack {
                        HStack {
                            ProfilePictureComponent(pictureURL: MyUser.emptyUser.profilePicture, size: .small, activityStatus: MyUser.emptyUser.activityStatus, showActivityStatus: true)
                            Text("Username")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading, 32)
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
        AddChatView()
    }
}
