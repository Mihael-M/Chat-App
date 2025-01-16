//
//  RegisterView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct RegisterView : View{
    @StateObject var viewModel = RegistrationViewModel()
    
    @State private var showRegisterAlert = false
    @State private var isPressed = false
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
            
            Spacer()
            
            Text("Our App Name 🌟")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                
                CustomTextField(icon: "at", prompt: "Email", value: $viewModel.email)
                HStack {
                    Image(systemName: viewModel.isEmailValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(viewModel.isPasswordLengthValid ? .green : .red)
                    Text("Must be a valid email format (e.g. user@example.com)")
                        .font(.footnote)
                        .textSelection(.disabled)
                        .foregroundColor(viewModel.isEmailValid ? .green : .red)
                }
                
                
                
                CustomTextField(icon: "key", prompt: "Password", value: $viewModel.password)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: viewModel.isPasswordLengthValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.isPasswordLengthValid ? .green : .red)
                        Text("At least 8 characters")
                            .foregroundColor(viewModel.isPasswordLengthValid ? .green : .red)
                    }
                    HStack {
                        Image(systemName: viewModel.containsUppercase ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.containsUppercase ? .green : .red)
                        Text("At least one uppercase letter")
                            .foregroundColor(viewModel.containsUppercase ? .green : .red)
                    }
                    HStack {
                        Image(systemName: viewModel.containsNumber ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.containsNumber ? .green : .red)
                        Text("At least one number")
                            .foregroundColor(viewModel.containsNumber ? .green : .red)
                    }
                }
                .font(.footnote)
                
                
            }
            .font(.body)
            .padding()
            
            
            Button(action:{
                Task{ try await viewModel.register() }
                showRegisterAlert = true
            })
            {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
                    .animation(.spring(), value: isPressed)
            }
            .disabled(
                !viewModel.isEmailValid ||
                !viewModel.isPasswordLengthValid ||
                !viewModel.containsUppercase ||
                !viewModel.containsNumber
            )
            .onTapGesture {
                isPressed.toggle()
            }
            
            Spacer()
            
            NavigationLink {
                LogInView()
            } label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width:60, height: 60)
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animation(.spring(), value: isPressed)
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
            .onTapGesture {
                isPressed.toggle()
            }
            
            Text("Already have an account?")
                .font(.callout)
        }
        .alert(isPresented: $showRegisterAlert) {
            Alert(
                title: Text("Registered succesfully!"),
                message: Text("Welcome to our app!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden()
        
    }
    
}


#Preview {
    RegisterView()
}
