//
//  ProfilePictureView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct ProfilePictureComponent: View {
    
    @State private var showPictureEditAlert = false
    @Binding var profileImageURL: String
    @Binding var activityStatus: Bool
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button(action: {
                showPictureEditAlert = true
            }) {
                Image(profileImageURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .foregroundStyle(Color.secondary)
            }
            
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(Color(.systemGreen))
                    .frame(width: 15, height: 15)
            }
            
        }
        .padding(.horizontal)
        .alert("Change Profile Picture", isPresented: $showPictureEditAlert) {
            Button("Choose from Library") {
                // choose from library...
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Would you like to change your profile picture?")
        }
    }
}

#Preview {
    @Previewable @State var exampleProfilePictureURL: String = "picture"
    ProfilePictureComponent(profileImageURL: $exampleProfilePictureURL, activityStatus: .constant(true))
}
