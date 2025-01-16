//
//  MessagesCountView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct MessagesCountComponent: View {
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("0")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Sent Messages")
                    .font(.caption)
            }
            Spacer()
            VStack {
                Text("0")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Received Messages")
                    .font(.caption)
            }
            Spacer()
        }
    }
}

#Preview {
    MessagesCountComponent()
}
