//
//  ForgottenPasswordView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ForgottenPasswordView: View {
    @State private var emailID: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .center, spacing: 15, content: {
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.down")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            Text("Forgot your password?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 25)
            
            Text("Please enter your email for recovering your password.")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTextField(icon: "at", prompt: "Email", value: $emailID)
                
                Button(action: {}, label: {
                    Text("Send recovery link.")
                })
                .disabled(emailID.isEmpty)
                
            }
            Spacer()
            
        })
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .interactiveDismissDisabled()
    }
}

#Preview {
    //ForgottenPasswordView()
}
