//
//  CustomGroupChatName.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 14.01.25.
//

import SwiftUI

import SwiftUI

struct CustomGroupChatNameView: View {
    @Binding var text: String
    var placeholder: String
    var characterLimit: Int? = nil
    var icon: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                }
                
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .font(.body)
            }
            
            if let limit = characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(limit)")
                        .font(.caption)
                        .foregroundColor(text.count > limit ? .red : .gray)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    @Previewable @State var groupName: String = ""
    CustomGroupChatNameView(
        text: $groupName,
        placeholder: "Enter group name",
        characterLimit: 25,
        icon: "person.3.fill"
    )
}
