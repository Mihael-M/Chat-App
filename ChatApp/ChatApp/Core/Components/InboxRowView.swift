//
//  ChatRowView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI

struct InboxRowView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ProfilePictureComponent(conversation: conversation, size: .small)
            
            if let latest = conversation.latestMessage {
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.displayTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 0) {
                        if latest.isMyMessage {
                            Text("You: ")
                                .font(.subheadline)
                                .foregroundStyle(Color(.systemGray))
                        } else {
                            Text("\(latest.senderName): ")
                                .font(.subheadline)
                                .foregroundStyle(Color(.systemGray))
                        }
                        HStack(spacing: 4) {
                            if let subtext = latest.subtext {
                                Text(subtext)
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.systemBlue))
                            }
                            if let text = latest.text {
                                Text(text)
                                    .lineLimit(1)
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.systemGray))
                                    //.frame(maxWidth: UIScreen.main.bounds.width - 120, alignment: .leading)
                            }
                        }
                    }
                }
                Spacer()
                if let date = latest.createdAt?.timeAgoFormat(){
                    HStack {
                        Text(date)
                        
                        Image(systemName: "chevron.right")
                    }
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
                }
            }
        }
        .frame(height: 80)
    }
}

#Preview {
    //InboxRowView()
}
