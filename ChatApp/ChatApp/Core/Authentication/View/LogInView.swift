//
//  LogInView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.12.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

private enum FocusableField: Hashable {
    case email
    case password
}

struct LogInView: View {
    @StateObject var viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showForgottenPasswordView: Bool = false
    @State private var isPressed: Bool = false
    @State private var showErrorAlert: Bool = false
    
    @FocusState private var focus: FocusableField?

    var body: some View {
            VStack(alignment: .center, spacing: 15) {
                Spacer()
                
                Text("Yapper")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                CustomTextField(icon: "at", prompt: "Email", value: $viewModel.email)
                    .focused($focus, equals: .email)
                    .onSubmit {
                        self.focus = .password
                    }
                CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $viewModel.password)
                    .focused($focus, equals: .password)
                    .onSubmit {
                        Task {
                            try await viewModel.login()
                        }
                    }

                
                Button("Forgot your password?") {
                    showForgottenPasswordView.toggle()
                }
                .font(.callout)
                
            
                Button {
                    Task {
                        try await viewModel.login()
                        if viewModel.loginError != nil {
                            showErrorAlert = true
                        }
                        
                    }
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
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error!"),
                    message: Text((viewModel.loginError?.description)!),
                    dismissButton: .default(Text("Try again"), action: {})
                )
            }
            .navigationBarBackButtonHidden()
        }
}

#Preview {
    LogInView()
}
