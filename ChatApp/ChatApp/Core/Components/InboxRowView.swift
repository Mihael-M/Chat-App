//
//  ChatRowView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 16.01.25.
//

import SwiftUI

struct InboxRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ProfilePictureComponent(user: MyUser.emptyUser, size: .medium, showActivityStatus: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Last message that is very extremely more than one line long")
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                Text("Date sent")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(Color(.systemGray))
        }
        .frame(height: 80)
    }
}

#Preview {
    InboxRowView()
}
