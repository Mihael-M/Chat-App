//
//  AddGroupChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct AddGroupChatView: View {
    @State private var userID: String = ""
    @State private var groupName: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager
    @State private var profileImage: Image = Image(systemName: "person.circle")
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                              .frame(width: 40, height: 5)
                              .foregroundColor(.gray.opacity(0.5))
                              .padding(.top, 8)
            CustomGroupChatNameView(text: $groupName, placeholder: "Enter group name (optional)",characterLimit: 25)
            
          Spacer()
            CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $userID)
//            List(){
//                HStack{
//                    //currently added users
//                    ScrollView{
//                        CustomUserView(profileImage: profileImage)
//                    }
//                    
//                    
//                }
//            }
            
            List(){
                // list of users
            }
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        
    }
}

#Preview {
    AddGroupChatView()
        .environmentObject(UserManager())
}
