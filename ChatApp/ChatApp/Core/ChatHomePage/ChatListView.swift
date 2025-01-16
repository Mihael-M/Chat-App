//
//  CustomChatView_LIst.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct ChatListView: View {
    
    @State var chats = [
        Chat(title: "Item 1",lastMessage: "This is the first item.", iconName: "star.fill"),
        Chat(title: "Item 2", lastMessage: "This is the second item.", iconName: "heart.fill"),
        Chat(title: "Item 3", lastMessage: "This is the third item.", iconName: "flame.fill")
    ]
    var body: some View {
            List(chats) { chat in
                HStack {
                    Image(systemName: chat.iconName)
                        .resizable()
                        .frame(width: 30, height: 30)

                        .padding(.trailing, 15)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(chat.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // Description of the item
                        Text(chat.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 8)
                .padding(.vertical, 5)
        }
    }
}

#Preview {
    ChatListView()
}
