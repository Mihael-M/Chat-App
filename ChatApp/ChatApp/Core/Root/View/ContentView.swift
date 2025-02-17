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
        Group {
            if viewModel.userSession != nil {
                ChatInboxView()
            } else {
                LogInView()
            }
        }
    }
}

#Preview {
    ContentView()
}

