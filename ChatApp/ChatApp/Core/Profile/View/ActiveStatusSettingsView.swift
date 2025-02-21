//
//  ActiveStatusSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct ActiveStatusSettingsView: View {
    @State private var isActive: Bool = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Section(){
                Toggle(isOn: $isActive) {
                    Text("Show active status")
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()
            Text("*Your friends and connections can see when you're active or recently active on this profile. You can see this info about them, too. To change this setting, turn it off wherever you're using Yapper and your Active Status will no longer be shown.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(10)
            
            Spacer()
        }
        .navigationTitle("Active Status")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.systemGray))
                }
            }
        }
    }
}

#Preview {
    ActiveStatusSettingsView()
}
