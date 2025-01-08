//
//  LogInView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.12.24.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var user: User
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
            
            CustomTextField(icon: "at", prompt: "Email", value: $user.email)
            CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $user.password)
            
            Button("Forgot your password?") {
                showForgottenPasswordView.toggle()
            }
                .font(.callout)
            
            CustomNavigatingButton(content: .icon(name: "arrow.right"), action: {}, destination: ChatHomePageView(), hideBackButton: true)
            
            
            Spacer()
            
            CustomNavigatingButton(content: .icon(name:"plus"), action: {}, destination: ProfileView(user: user,isEditing: $isEditing,newUser: $newUser), hideBackButton: false)
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
    ContentView()
}
