//
//  RegisterView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case username
    case password
    case repeatPassword
}

struct RegisterAuthView : View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    @State private var isPressed: Bool = false
    @State private var navigateNext: Bool = false
    @State private var showErrorAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            
            Spacer()
            
            //logo
            Text("Yapper🌟")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            //text fields
            VStack(alignment: .leading, spacing: 20) {
                
                CustomTextField(icon: "at", prompt: "Email", value: $viewModel.email)
                    .focused($focus, equals: .email)
                    .onSubmit {
                        self.focus = .username
                    }
                
                Divider()
                
                //email validity
                HStack {
                    Image(systemName: viewModel.isEmailValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(viewModel.isEmailValid ? .green : .red)
                    Text("Must be a valid email format (e.g. user@example.com)")
                        .font(.footnote)
                        .textSelection(.disabled)
                        .foregroundColor(viewModel.isEmailValid ? .green : .red)
                }
                
                CustomTextField(icon: "person", prompt: "Username", value: $viewModel.username)
                    .focused($focus, equals: .username)
                    .onSubmit {
                        self.focus = .password
                    }
                
                Divider()
                
                CustomTextField(icon: "key", prompt: "Password", isPassword: true, value: $viewModel.password)
                    .focused($focus, equals: .password)
                    .onSubmit {
                        self.focus = .repeatPassword
                    }
                
                Divider()
                
                CustomTextField(icon: "key", prompt: "Repeat password", isPassword: true, value: $viewModel.repeatedPassword)
                    .focused($focus, equals: .repeatPassword)
                    .onSubmit {
                        Task {
                        }
                    }
                
                Divider()
                
                //password validity
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

                    HStack {
                        Image(systemName: viewModel.passwordMatches ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.passwordMatches ? .green : .red)
                        Text("Password must match")
                            .foregroundColor(viewModel.passwordMatches ? .green : .red)
                    }
                }
                .font(.footnote)
                
                
                
            }
            .font(.body)
            .padding()
            
            //handle register
            Button {
                Task {
                    try await viewModel.registerPart1()
                    if viewModel.registerError != nil {
                        showErrorAlert.toggle()
                    } else {
                        navigateNext.toggle()
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
            .disabled(
                            !viewModel.isEmailValid ||
                            !viewModel.isPasswordLengthValid ||
                            !viewModel.containsUppercase ||
                            !viewModel.containsNumber ||
                            !viewModel.isValidPhoneNumber
                        )
            .onTapGesture {
                isPressed.toggle()
            }
            
            Spacer()
            
            //log in page
            Button {
                dismiss()
            } label: {
                VStack {
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
                    .padding(.vertical)
                    Text("Already have an account?")
                        .font(.footnote)
                }
            }
            .padding(.vertical)
            .onTapGesture {
                isPressed.toggle()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $navigateNext, destination: {
            WelcomeView()
        })
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error!"),
                message: Text((viewModel.registerError?.description)!),
                dismissButton: .default(Text("Try again"), action: {viewModel.clearAuthFields()})
            )
        }
    }
    
}


#Preview {
    NavigationStack {
        RegisterAuthView()
    }
}
