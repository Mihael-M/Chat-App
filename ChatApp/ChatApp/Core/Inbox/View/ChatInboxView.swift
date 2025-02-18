//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ChatInboxView: View {
    @ObservedObject var dataStorage = DataStorageService.shared
    @StateObject var viewModel = ChatInboxViewModel()
    
    @State private var showAddChatView: Bool = false
    @State var navPath = NavigationPath()
    
    private var user: MyUser? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                ActiveUsersView()
                
                List (viewModel.filteredConversations) { conversation in
                    InboxRowView(conversation: conversation)
                        .background(
                            NavigationLink("", value: conversation)
                                .opacity(0)
                        )
                        .listRowSeparator(.hidden)
                }
                
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 128)
            }
            .refreshable {
                await viewModel.getData()
            }
            .fullScreenCover(isPresented: $showAddChatView, content: {
                AddChatView(isPresented: $showAddChatView, navPath: $navPath)
            })
            .navigationDestination(for: MyUser.self, destination: { user in
                ProfileSettingsView(user: user)
            })
            .navigationDestination(for: Conversation.self) { conversation in
                ConversationView(viewModel: ConversationViewModel(conversation: conversation))
            }
            .navigationDestination(for: MyUser.self) { user in
                ConversationView(viewModel: ConversationViewModel(user: user))
            }
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
                            ProfilePictureComponent(user: user, size: .xsmall)
                        }
                    }
                }
            }
        }
        .task {
            viewModel.subscribeToUpdates()
        }
    }
}

#Preview {
    ChatInboxView()
}

