//
//  ActiveUsersView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI

struct ActiveUsersView: View {
    let conversation: Conversation
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(0...10, id: \.self) { user in
                    VStack{
                        ZStack(alignment: .bottomTrailing) {
                            ProfilePictureComponent(conversation: conversation, size: .small)
                            
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 20, height: 20)
                                Circle()
                                    .fill(Color(.systemGreen))
                                    .frame(width: 15, height: 15)
                            }
                        }
                        
                        Text("Username")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemGray))
                    }
                }
            }
            .padding()
        }
        .frame(height: 128)
    }
}

#Preview {
    //ActiveUsersView()
}
