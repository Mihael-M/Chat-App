//
//  CustomTextField_Circle.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct CustomTextField_Circle: View {
    var icon : String
    var iconColor : Color = .secondary
    var prompt : String
    @Binding var value: String
    var body: some View {
        HStack(alignment: .top, spacing: 1, content: {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 50)
                .offset(y: 2)
            
           
                TextField(prompt, text: $value)
                    .foregroundColor(.secondary)
                    .padding(.leading, 0.5)
                    .padding(.bottom, 0.5)
                    .padding(.trailing, 5)
                    
            
        })
        .background(Color.gray.cornerRadius(10).opacity(0.1).frame(height: 35))
    }
}

#Preview {
    @Previewable @State var userID = ""
    
    CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $userID)
}
