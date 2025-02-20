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
    @State private var showSearchView: Bool = false
    @State var navPath = NavigationPath()
    @State private var text : String = ""
    private var user: MyUser? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                if viewModel.filteredConversations.isEmpty {
                    Text("Add friends from the + tab")
                        .padding(.vertical,UIScreen.main.bounds.height/2.5)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                else{
                    List(viewModel.filteredConversations){
                        conversation in
                        ActiveUsersView(conversation: conversation)
                    }
                    
                    List (viewModel.filteredConversations) { conversation in
                        InboxRowView(conversation: conversation)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navPath.append(conversation)
                            }
                            .listRowSeparator(.hidden)
                    }
                    
                    .listStyle(PlainListStyle())
                    .frame(height: UIScreen.main.bounds.height - 128)
                }
            }
            .refreshable {
                viewModel.getData()
            }
            .fullScreenCover(isPresented: $showAddChatView, content: {
                AddChatView(isPresented: $showAddChatView, navPath: $navPath)
            })
            .fullScreenCover(isPresented: $showSearchView, content: {
                SearchView()
                    
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
                            Button{
                                showSearchView.toggle()
                            }
                            label:{
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Color(.systemGray))
                            }
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
                        NavigationLink(destination: {ProfileSettingsView()}, label: {ProfilePictureComponent(user: user, size: .xsmall)})
                    }
                }
            }
        }
    }
}

#Preview {
    ChatInboxView()
}

