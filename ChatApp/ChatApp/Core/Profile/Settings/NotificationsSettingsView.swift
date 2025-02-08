//
//  NotificationsSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @State private var isActiveNotifications: Bool = false
    var body: some View {
            VStack {
                Section(){
                    Toggle(isOn: $isActiveNotifications) {
                        Text("Receive notifications")
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                Text("Recieve notifications when you are not in the app.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
        }
    }
}

#Preview {
    NotificationsSettingsView()
}
