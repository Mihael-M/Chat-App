//
//  ProfileHeaderView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.02.25.
//


import SwiftUI

struct ProfileHeaderView: View {
    let user: MyUser
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy"
        return formatter.string(from: user.date_of_birth)
    }
    
    var body: some View {
        VStack() {
            
            VStack(spacing: 10) {
                //pic and stats
                HStack {
                    ProfilePictureComponent(pictureURL: MyUser.emptyUser.profilePicture, size: .medium)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        MessagesStatView(value: user.messagesSent, title: "Sent messages")
                        
                        MessagesStatView(value: user.messagesReceived, title: "Received messages")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                //user info
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.base.name)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text(user.phone_number)
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
    ProfileHeaderView(user: MyUser.emptyUser)
}
