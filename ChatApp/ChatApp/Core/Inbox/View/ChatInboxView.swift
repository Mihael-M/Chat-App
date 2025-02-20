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
    @State private var search: Bool = true
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
            .navigationDestination(for: Conversation.self) { conversation in
                ConversationView(viewModel: ConversationViewModel(conversation: conversation))
            }
            .navigationDestination(for: MyUser.self) { user in
                ConversationView(viewModel: ConversationViewModel(user: user))
            }
            .toolbar {
                //search and title
                ToolbarItem(placement: .topBarLeading) {
                    if search{
                        HStack {
                            Button{
                                search.toggle()
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
                    else{
                        CustomTextField(icon: "magnifyingglass", prompt: "Search user...", value: $viewModel.searchText)
                            .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
                            .animation(.smooth.speed(5))
                            .onSubmit
                            {
                                search.toggle()
                                viewModel.searchText = ""
                            }
                            
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
                        NavigationLink(destination: {ProfileSettingsView(user: user ?? MyUser.emptyUser)}, label: {ProfilePictureComponent(user: user, size: .xsmall)})
                    }
                }
            }
        }
    }
}

#Preview {
    ChatInboxView()
}

