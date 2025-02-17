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
    @StateObject var viewModel = ConversationViewModel()
    let user: MyUser
    
    @Environment(\.dismiss) var dismiss
    
        var body: some View {
        ChatView(messages: viewModel.messages, chatType: .comments, replyMode: .answer) {  _ in
            //viewmodel logic
        }
        .mediaPickerTheme(
            main: .init(
                text: .white,
                albumSelectionBackground: Color(.systemGray6),
                fullscreenPhotoBackground: Color(.systemGray6)
            ),
            selection: .init(
                emptyTint: .white,
                emptyBackground: .black.opacity(0.25),
                selectedTint: Color(.systemBlue),
                fullscreenTint: .white
            )
        )
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
                    
                    //add logic for groups
                    ProfilePictureComponent(user: user, size: .small, showActivityStatus: true)
                    VStack(alignment: .leading) {
                        Text(user.nickname)
                            .font(.body)
                        Text(user.base.name)
                            .font(.footnote)
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
    @Previewable @StateObject var viewModel = ConversationViewModel()
    NavigationStack {
        ConversationView(user: MyUser.emptyUser)
    }
}
