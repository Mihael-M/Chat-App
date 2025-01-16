//
//  ProfileSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct ProfileSettingsView: View {
    var body: some View {
        VStack {
            ProfileView(isEditing:.constant(false))
            List {
                Section {
                    ForEach(SettingOptionViewModel.allCases, id: \.self) { option in
                        HStack {
                            
                            NavigationLink(destination: destinationView(for: option), label: {
                                Image(systemName: option.imageName)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(option.imageBackgroundColor)
                                Text(option.title)
                            })
                        }
                    }
                }
                Section {
                    Button("Log out"){
                        AuthenticationService.authenticator.signOut()
                    }
                    .foregroundStyle(.red)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Your profile")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    @ViewBuilder
    private func destinationView(for option: SettingOptionViewModel) -> some View {
        switch option {
        case .editProfile: EditProfileView()
        case .darkMode: DarkModeSettingsView()
        case .notifications: NotificationsSettingsView()
        case .activeStatus: ActiveStatusSettingsView()
        }
    }
}


#Preview {
    ProfileSettingsView()
}
