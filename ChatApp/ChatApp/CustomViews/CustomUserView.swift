//
//  CustomUserView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 14.01.25.
//

import SwiftUI

struct CustomUserView: View {
    @State var profileImage: Image
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
               
            }) {
                profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .foregroundStyle(Color.secondary)
                    .padding()
            }
            Button(action: {
                // Handle remove here
            }) {
                Image(systemName: "multiply.circle")
                    .resizable()
                    .foregroundStyle(Color.gray)
                    .frame(width: 30, height: 30)
                
            }
        }
    }
}

#Preview {
    let Image = Image(systemName: "person.circle")
    CustomUserView(profileImage: Image)
}
