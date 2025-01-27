//
//  MessagesCountView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct MessagesStatView : View {
    let value: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.footnote)
        }
        .frame(width: 120)
    }
}


#Preview {
    MessagesStatView(value: 0, title: "Messages")
}
