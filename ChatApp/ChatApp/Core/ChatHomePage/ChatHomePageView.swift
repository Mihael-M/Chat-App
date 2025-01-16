//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ChatHomePageView: View {
    @StateObject var chatManager : ChatManager
    
    @State private var user = UserModel.emptyUser
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
            .navigationDestination(for: UserModel.self, destination: { user in
                ProfileSettingsView()
            })
            .sheet(isPresented: $showAddChatView, content: {
                AddChatView()
                    .presentationDetents([.height(300)])
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    
                    HStack {
                        Button(action: {
                            // Add search functionality here
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(Color.secondary)
                            
                        }
                        Text("Your chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            showAddChatView.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(Color.secondary)
                        }
                        
                        NavigationLink(value: user) {
                            Image(user.account.profilePictureURL ?? "")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
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

