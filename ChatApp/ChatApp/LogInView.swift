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

    var body: some View {
        VStack(alignment: .center, spacing: 15, content: {
            Spacer()
            
            Text("Our App Name 🌟")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            CustomTextField(icon: "at", prompt: "Email", value: $user.email)
            CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $user.password)
            
            
            Button(action: {
                //login logic
            }, label: {
                ZStack{
                    Circle()
                        .fill(.blue)
                        .frame(width:60, height: 60)
                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            })
            
            Spacer()
            
            Button(action: {}, label: {
                VStack {
                   
                        NavigationLink{
                            ProfileView(user: user,isEditing: $isEditing,newUser: $newUser)
                        }
                        label:{
                            ZStack{
                                Circle()
                                    .fill(.blue)
                                    .frame(width:60, height: 60)
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundStyle(.white)
                            }
                        }
                    Text("Sign Up")
                        .font(.callout)
                }
            })
            
            
        })
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
    }
}

#Preview {
    ContentView()
}
