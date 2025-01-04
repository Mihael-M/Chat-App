//
//  ContentView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 26.12.24.
//

import SwiftUI

struct ContentView : View {
    @StateObject private var user = User() 

    var body: some View {
        NavigationStack {
            LogInView(user: user)
        }
    }
}

#Preview {
    ContentView()
}
