//
//  ContentView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 26.12.24.
//

import SwiftUI

struct ContentView : View {
    @StateObject var chatManager: ChatManager = ChatManager()

    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ChatHomePageView(chatManager: chatManager)
            } else {
                LogInView()
            }
        }
    }

}

#Preview {
    let viewModel = ContentViewModel()
    
    ContentView()
}
