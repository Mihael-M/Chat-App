//
//  ContentView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 26.12.24.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject private var chatManager: ChatManager
    @EnvironmentObject private var userManager: UserManager
    var body: some View {
        NavigationStack {
            LogInView()
                .environmentObject(userManager)
                .environmentObject(chatManager)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ChatManager())
        .environmentObject(UserManager())
}
