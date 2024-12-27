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
    var body: some View {
        VStack(alignment: .center, spacing: 15, content: {
            Spacer()
            
            Text("Our App Name 🌟")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            CustomTextField(icon: "at", prompt: "Email", value: $email)
            CustomTextField(icon: "key", prompt: "Password",isPassword: true, value: $password)
            
            
            Button(action: {}, label: {
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
                    ZStack{
                        Circle()
                            .fill(.blue)
                            .frame(width:60, height: 60)
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundStyle(.white)
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
