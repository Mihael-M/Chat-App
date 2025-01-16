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
    @State private var isPressed: Bool = false

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
                if let error = viewModel.loginError {
                    HStack{
                        Text(error)
                            .foregroundColor(.red)
                            .font(.callout)
                        Spacer()
                    }
                }
                
                Button("Forgot your password?") {
                    showForgottenPasswordView.toggle()
                }
                .font(.callout)
            
                Button {
                    Task {try await viewModel.login()}
                } label: {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                            .frame(width:60, height: 60)
                            .scaleEffect(isPressed ? 0.98 : 1.0)
                            .animation(.spring(), value: isPressed)
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                .onTapGesture {
                    isPressed.toggle()
                }
           
                
                Spacer()
                
                
                NavigationLink {
                    RegisterView()
                } label: {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                            .frame(width:60, height: 60)
                            .scaleEffect(isPressed ? 0.98 : 1.0)
                            .animation(.spring(), value: isPressed)
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                .onTapGesture {
                    isPressed.toggle()
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
