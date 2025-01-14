//
//  AddGroupChatView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct AddGroupChatView: View {
    @State private var userID: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userManager: UserManager
    var body: some View {
        VStack {
            
            
            CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $userID)
        }
    }
}

#Preview {
    AddGroupChatView()
}
