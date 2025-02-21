//
//  ChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//
//
import SwiftUI
import ExyteChat

struct ConversationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ConversationViewModel
    
    @State var showChatSettings: Bool = false
 
    var body: some View {
        ChatView(messages: viewModel.messages, chatType: .conversation, replyMode: .answer) { draft in
            viewModel.sendMessage(draft)
            if viewModel.users.contains(where: {$0.base.id == "AI_Bot"}) {
                Task{
                    /// Generate AI response using AIManager
                    let (_, aiResponseText) = await AIManager.shared.getBotResponse(draft.text)
                    try await viewModel.sendAIMessage(aiResponseText)
                }
            }
        }
        .dismissKeyboardOnDrag()
        .mediaPickerTheme(
            main: .init(
                text: .white,
                albumSelectionBackground: Color(.darkGray),
                fullscreenPhotoBackground: Color(.darkGray)
            ),
            selection: .init(
                emptyTint: .white,
                emptyBackground: .black.opacity(0.25),
                selectedTint: Color(.systemBlue),
                fullscreenTint: .white
            )
        )
        .onDisappear {
            viewModel.resetUnreadCounter()
        }
        .overlay(
            ChatProfileView(isPresented: $showChatSettings, user: viewModel.users.first ?? MyUser.emptyUser)
                .offset(y: showChatSettings ?  -80 : -UIScreen.main.bounds.height) // Slide in from top
                .animation(.spring(), value: showChatSettings),
                            alignment: .top
                )
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    if let conversation = viewModel.conversation, conversation.isGroup {
                        ProfilePictureComponent(conversation: conversation, size: .xsmall)
                        Text(conversation.title)
                            .font(.body)
                    } else if let user = viewModel.users.first {
                        ProfilePictureComponent(user: user, size: .xsmall, showActivityStatus: true)
                        VStack(alignment: .leading) {
                            Text(user.nickname)
                                .font(.body)
                            Text(user.base.name)
                                .font(.footnote)
                        }
                        
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        showChatSettings = true
                    }
                }
            }
        }
    }
}

#Preview {
    
    NavigationStack {
        ConversationView(viewModel: ConversationViewModel(user: MyUser.emptyUser))
    }
}
