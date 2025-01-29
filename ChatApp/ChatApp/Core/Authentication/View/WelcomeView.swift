//
//  WelcomeView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 26.01.25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text("Welcome to Yapper! ")
                .font(.title2)
                .fontWeight(.bold)
            Text("Click here to add more information about you before you start using our app.")
                .font(.footnote)
                .foregroundStyle(Color(.systemGray))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            NavigationLink {
                EditProfileView(account: .emptyAccount)
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(radius: 5)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
                    .animation(.spring(), value: isPressed)
            }
            .onTapGesture {
                isPressed.toggle()
            }
            Spacer()
        }
    }
}

#Preview {
    WelcomeView()
}
