//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ChatHomePageView: View {
    @StateObject var chatManager : ChatManager
    //@EnvironmentObject var userManager : UserManager
    @State private var showAddChatView : Bool = false
    @State private var isEditing : Bool = false
    @State private var newUser : Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                ActiveUsersView()
                
                List {
                    ForEach(0...10, id: \.self) { message in
                        ChatRowView()
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 128)
                
                //            VStack{
                //                Divider()
                //                Spacer()
                //
                //                if chatManager.chats.isEmpty{
                //                    Text("No chats yet")
                //                        .font(.callout)
                //                        .foregroundColor(.gray)
                //                        .padding()
                //                }
                //                else{
                //                    CustomChatView_List(chats: chatManager.chats)
                //
                //                }
                //            }
                      
                //       }
                
            }
            .sheet(isPresented: $showAddChatView, content: {
                AddChatView()
                    .presentationDetents([.height(300)])
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    
                    Button(action: {
                        // Add search functionality here
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                        
                    }
                    
                }
                
                ToolbarItem(placement: .topBarLeading, content: {
                    Text("Your chats")
                        .font(.title)
                        .fontWeight(.semibold)
                })
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        showAddChatView.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color.secondary)
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        
                    } label: {
                        NavigationLink(destination: ProfileView(isEditing: $isEditing)) {
                            Image(systemName: "person.crop.circle")
                                .font(.title2)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
//        let chatManager = ChatManager()
//        let userManager = UserManager()
//        chatManager.chats = [
//            Chat(title: "Alice", lastMessage: "Hi there!",iconName: "person.circle.fill"),
//            Chat(title: "Bob", lastMessage: "How's it going?",iconName: "person.circle.fill")
//        ]
//    
//    ChatHomePageView(chatManager: chatManager)
//            .environmentObject(chatManager)
//            .environmentObject(userManager)
}
