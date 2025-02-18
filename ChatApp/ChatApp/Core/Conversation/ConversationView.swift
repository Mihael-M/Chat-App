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
    
    var body: some View {
        ChatView(messages: viewModel.messages, chatType: .conversation, replyMode: .answer) { draft in
            viewModel.sendMessage(draft)
        }
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
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(.black))
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
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("chat settings")
                } label:  {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(.black))
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
