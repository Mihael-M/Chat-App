//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ChatInboxView: View {
    @State var showAddChatView: Bool = false
    @State private var user = MyUser.emptyUser
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ActiveUsersView()
                
                List {
                    ForEach(0 ... 10, id: \.self) { message in
                        InboxRowView()
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 128)
            }
            .fullScreenCover(isPresented: $showAddChatView, content: {
                AddChatView()
            })
            .navigationDestination(for: MyUser.self, destination: { user in
                ProfileSettingsView(user: user)
            })
            .toolbar {
                //search and title
                ToolbarItem(placement: .topBarLeading) {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("Your chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    
                }
                //add chat and profile
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            showAddChatView.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(Color(.systemGray))
                        }
                        
                        NavigationLink (value: user) {
                            ProfilePictureComponent(pictureURL: user.profilePicture, size: .small)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ChatInboxView()
}

