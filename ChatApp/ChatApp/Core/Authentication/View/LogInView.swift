//
//  LogInView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.12.24.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
}

struct LogInView: View {
    @State private var isPressed: Bool = false
    
    @State private var email:  String = ""
    @State private var password: String = ""
    
    @FocusState private var focus: FocusableField?
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                //logo
                Text("Yapper🌟")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()

                //text fields
                VStack(alignment: .center, spacing: 15) {
                    CustomTextField(icon: "at", prompt: "Email", value: $email)
                        .focused($focus, equals: .email)
                        .onSubmit {
                            self.focus = .password
                        }
                    
                    Divider()
                    
                    CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $password)
                        .focused($focus, equals: .password)
                        .onSubmit {
                            
                        }
                    
                    Divider()
                }
                .padding(.horizontal)
                
                //forgot password
                Button {
                    print("forgot password")
                } label: {
                    Text("Forgot your password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 32)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                //login button
                Button {
                        print("login")
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
                    .padding(.vertical)
                }
                .onTapGesture {
                    isPressed.toggle()
                }
                
                Spacer()
                
                //sign up link
                NavigationLink {
                    RegisterView()
                } label: {
                    VStack  {
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
                        .padding(.vertical)
                        Text("Don't have an account?")
                            .font(.footnote)
                    }
                }
                .padding(.vertical)
                .onTapGesture {
                    isPressed.toggle()
                }
            }
        }
    }
}

#Preview {
    LogInView()
}
