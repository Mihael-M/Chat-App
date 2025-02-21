//
//  DarkModeSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

enum DarkModeOption: String, CaseIterable, Identifiable {
    case light = "Light Mode"
    case dark = "Dark Mode"
    case system = "System"
    
    var id: String { self.rawValue }
    
    /// Converts `DarkModeOption` to SwiftUI `ColorScheme`
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

struct DarkModeSettingsView: View {
    @AppStorage("darkModeOption") private var selectedMode: DarkModeOption = .system
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Picker("Dark Mode", selection: $selectedMode) {
                ForEach(DarkModeOption.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            
            Text("*If system is selected, the app will automatically use your device's appearance system settings.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(10)
        }
        .navigationTitle("Dark Mode")
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
    DarkModeSettingsView()
}
