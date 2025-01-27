//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

enum toolbarOption {
    case search
    case addChat
    case userProfile
}

struct ChatHomePageView: View {
    @State private var account = Account.emptyAccount
    @State private var showAddChatView : Bool = false
    @State private var isEditing : Bool = false
    @State private var newUser : Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ActiveUsersView()
                
                List {
                    ForEach(0...10, id: \.self) { message in
                        ChatRowComponent()
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
            .navigationDestination(for: toolbarOption.self,
                destination: { destination in
                switch destination {
                case .search:
                    SearchView()
                case .addChat:
                    AddChatView()
                case .userProfile:
                    ProfileSettingsView()
                }
            })
            .sheet(isPresented: $showAddChatView, content: {
                AddChatView()
                    .presentationDetents([.height(300)])
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    
                    HStack {
                        NavigationLink(value: toolbarOption.search) {
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
                        
                        NavigationLink(value: toolbarOption.userProfile) {
                            Image(account.profilePictureURL ?? "")
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
    ChatHomePageView()
}

