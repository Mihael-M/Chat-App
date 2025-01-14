//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ChatHomePageView: View {
    @EnvironmentObject var chatManager : ChatManager
    @EnvironmentObject var userManager : UserManager
    @State private var showAddChatView : Bool = false
    @State private var isEditing : Bool = false
    @State private var newUser : Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                Divider()
                Spacer()
                if chatManager.chats.isEmpty{
                    Text("No chats yet")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding()
                }
                else{
                    CustomChatView_List(chats: chatManager.chats)
                    
                }
               
            }
            .sheet(isPresented: $showAddChatView, content: {
                AddChatView()
                    .environmentObject(userManager)
                    .presentationDetents([.height(300)])
            })
        }
        .navigationTitle("Our App Name :)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button(action: {
                    // Add search functionality here
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                        
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    showAddChatView.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    
                }) {
                    NavigationLink(destination: ProfileView(isEditing: $isEditing, newUser: $newUser)) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                    }
                }
                
            }
                
        }
    }
}

#Preview {
    let chatManager = ChatManager()
    let userManager = UserManager()
    chatManager.chats = [
        Chat(title: "Alice", lastMessage: "Hi there!",iconName: "person.circle.fill"),
        Chat(title: "Bob", lastMessage: "How's it going?",iconName: "person.circle.fill")
    ]

    return ChatHomePageView()
        .environmentObject(chatManager)
        .environmentObject(userManager)
}
