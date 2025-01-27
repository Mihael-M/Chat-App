//
//  ContentView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 26.12.24.
//

import SwiftUI

struct ContentView : View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack() {
            Group {
                if viewModel.userSession == nil {
                    LogInView()
                } else {
                    ChatHomePageView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

