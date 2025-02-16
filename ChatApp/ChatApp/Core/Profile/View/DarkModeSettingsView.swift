//
//  DarkModeSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI
enum DarkModeOption : String, CaseIterable,Identifiable {
    case light = "Light Mode"
    case dark = "Dark Mode"
    case system = "System"
    
    var id : String {
        self.rawValue
    }
}
struct DarkModeSettingsView: View {
    @State private var selectedMode : DarkModeOption = .system
    var body: some View {
        VStack
        {
            Picker("Dark Mode", selection: $selectedMode)
            {
                ForEach(DarkModeOption.allCases){
                    mode in Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            
            Text("*If system is selected, the app will automaticly use your device's appearance system settings.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(10)
        }
    }
}

#Preview {
    DarkModeSettingsView()
}
