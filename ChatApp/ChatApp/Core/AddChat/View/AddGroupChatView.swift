//
//  AddGroupChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct AddGroupChatView: View {
    @State private var searchText: String = ""
    @State private var groupName: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var profileImage: Image = Image(systemName: "person.circle")
    //    var filteredUsers:[String]
    //    {
    //        if userID.isEmpty {
    //            return []
    //        }
    //        else{
    //            return [].filter( $0.localisedCaseInsensitiveContains(userID))
    //        }
    //    }
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                              .frame(width: 40, height: 5)
                              .foregroundColor(.gray.opacity(0.5))
                              .padding(.top, 8)
            CustomGroupChatNameView(text: $groupName, placeholder: "Enter group name (optional)",characterLimit: 25)
            
          Spacer()
            CustomTextField(icon: "magnifyingglass", prompt: "Search user...", value: $searchText)
                .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
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
}
