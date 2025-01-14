//
//  LogInView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.12.24.
//

import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var chatManager: ChatManager

    @State private var isEditing: Bool = true
    @State private var newUser: Bool = true
    @State private var showForgottenPasswordView: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 15, content: {
            Spacer()
            
            Text("Our App Name 🌟")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            CustomTextField(icon: "at", prompt: "Email", value: $email)
            CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $password)
            
            Button("Forgot your password?") {
                showForgottenPasswordView.toggle()
            }
                .font(.callout)
            
            
            CustomNavigatingButton(content: .icon(name: "arrow.right"), action: {}, destination: ChatHomePageView()
                .environmentObject(userManager)
                .environmentObject(chatManager), hideBackButton: true)
            
            Spacer()
            
            CustomNavigatingButton(content: .icon(name:"plus"), action: {}, destination: ProfileView(isEditing: $isEditing,newUser: $newUser)
                .environmentObject(userManager)
                .environmentObject(chatManager), hideBackButton: true)
            Text("Don't have an account?")
                .font(.callout)
            
        })
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .sheet(isPresented: $showForgottenPasswordView, content: {
            ForgottenPasswordView()
                .presentationDetents([.height(400)])
        })
    }
}

#Preview {
    let chatManager = ChatManager()
    let userManager = UserManager()
    
    LogInView()
        .environmentObject(chatManager)
        .environmentObject(userManager)
}
