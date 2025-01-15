//
//  LogInView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LogInView: View {
    
    //@EnvironmentObject var userManager: UserManager
    //@EnvironmentObject var chatManager: ChatManager
    
    @StateObject var viewModel = LoginViewModel()
    
    @State private var showForgottenPasswordView: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 15) {
                Spacer()
                
                Text("Our App Name 🌟")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                CustomTextField(icon: "at", prompt: "Email", value: $viewModel.email)
                CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $viewModel.password)
                
                Button("Forgot your password?") {
                    showForgottenPasswordView.toggle()
                }
                .font(.callout)
                
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width:60, height: 60)
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                
                NavigationLink {
                    RegisterView()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width:60, height: 60)
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                
                Text("Don't have an account?")
                    .font(.callout)
                
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .sheet(isPresented: $showForgottenPasswordView, content: {
                ForgottenPasswordView()
                    .presentationDetents([.height(400)])
            })
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    LogInView()
}
