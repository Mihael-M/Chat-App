//
//  CustomTextField.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.12.24.
//

import SwiftUI

struct CustomTextField: View {
    var icon : String
    var iconColor : Color = .gray
    var prompt : String
    var isPassword: Bool = false
    @Binding var value: String
    @State private var showPassword: Bool = false
    var body: some View {
        HStack(alignment: .top, spacing: 15, content: {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 30)
                .offset(y: 5)
            
            VStack(alignment: .leading, spacing: 15, content: {
                if isPassword {
                    Group {
                        if showPassword {
                            TextField(prompt, text: $value)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        } else {
                            SecureField(prompt, text: $value)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                    }
                } else {
                    TextField(prompt, text: $value)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            })
            .overlay(alignment: .trailing) {
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                    })}
                
            }
        })
    }
}
