//
//  RegisterView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct RegisterView : View{
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var chatManager: ChatManager
    @State private  var email: String = ""
    @State private  var password: String = ""
    @Binding var newUser: Bool
    @State private var showRegisterAlert = false
    @State private var isPressed = false
    var body: some View{
        NavigationStack{
            
            
            VStack(spacing: 30){
                VStack(alignment: .leading, spacing: 20) {
                    
                    CustomTextField(icon: "at", prompt: "Email", value: $email)
                    Text("Must be valid email")
                        .font(.footnote)
                        .foregroundStyle(.red)
                    CustomTextField(icon: "key", prompt: "Password", value: $password)
                    Text("Must be at least 8 characters")
                        .font(.footnote)
                        .foregroundStyle(.red)
                    
                    
                }
                .font(.body)
                .padding(.horizontal)
                HStack(spacing : 20)
                {
                    Button(action:{
                    })
                    {
                        NavigationLink("Already have an account", destination: LogInView().navigationBarBackButtonHidden(true))
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
                    .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                        isPressed = pressing
                    }, perform: {})
                    
                    
                    Button(action:{
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
                    .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                        isPressed = pressing
                    }, perform: {})
                    
                    
                }
            }
            .alert("Profile Created!", isPresented: $showRegisterAlert) {
                Button("Continue", role: .cancel) {newUser = false}
            } message: {
                Text("Set up your profile")
            }
        }
            
    }
    
}

#Preview {
    RegisterView(newUser: .constant(true))
}
