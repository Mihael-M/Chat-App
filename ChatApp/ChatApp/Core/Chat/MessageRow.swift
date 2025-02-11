//
//  MessageRow.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//

import SwiftUI

struct MessageRowView: View {
    let text: String
    let isMyMessage: Bool

    var body: some View {
        HStack {
            if isMyMessage { Spacer() }

            Text(text)
                .padding()
                .background(isMyMessage ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: 250, alignment: isMyMessage ? .trailing : .leading)

            if !isMyMessage { Spacer() }
        }
        .padding(.horizontal)
    }
}
#Preview {
    MessageRowView(text: "sample text", isMyMessage: true)
}
