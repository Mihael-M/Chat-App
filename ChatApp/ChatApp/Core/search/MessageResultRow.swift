//
//  MessageResultRow.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 21.02.25.
//


import SwiftUI
import ExyteChat

// 🔎 Message Search Result Row with Highlighted Text
struct MessageSearchResultRow: View {
    let message: Message
    let searchText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            highlightedText(text: message.text, highlight: searchText)
                .font(.body)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(12)

            HStack {
                Text(message.user.name)
                    .font(.footnote)
                    .foregroundColor(.blue)

                Text("• \(formattedDate(message.createdAt))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .transition(.opacity)
    }

    // 🎨 Highlight matched text
    private func highlightedText(text: String, highlight: String) -> Text {
        guard !highlight.isEmpty else { return Text(text) } // Return normal text if no search term

        let parts = text.lowercased().components(separatedBy: highlight.lowercased())
        var result: Text = Text("")

        for (index, part) in parts.enumerated() {
            if index > 0 { result = result + Text(highlight).bold().foregroundColor(.blue) }
            result = result + Text(part)
        }
        return result
    }

    // 🗓 Format date nicely
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
