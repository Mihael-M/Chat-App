//
//  AddChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct AddChatView: View {
    @State private var userID: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $userID)
            Button(action: {
                
            })
            {
                NavigationLink(destination: AddGroupChatView()) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .font(.title2)
                            
                        Text("Group chat")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.primary)
                }
            }
            List(){
                
            }
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .interactiveDismissDisabled()
    }
}

#Preview {
    AddChatView()
}
