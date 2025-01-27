//
//  SettingsOptionViewModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//
import Foundation
import SwiftUI

enum SettingOption: Int, CaseIterable, Identifiable{
    case editProfile
    case darkMode
    case notifications
    case activeStatus
    
 
    var title: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .darkMode: return "Dark Mode"
        case .notifications: return "Notifications"
        case .activeStatus: return "Active Status"
        }
    }
    
    var imageName: String {
        switch self {
        case .editProfile: return "pencil.circle.fill"
        case .darkMode: return "moon.circle.fill"
        case .notifications: return "bell.circle.fill"
        case .activeStatus: return "message.badge.circle.fill"
        }
    }
    
    var imageBackgroundColor: Color {
        switch self {
        case .editProfile: return Color.blue
        case .darkMode: return Color.indigo
        case .notifications: return Color.purple
        case .activeStatus: return Color.green
        }
    }
    
    @ViewBuilder
    var destination : some View {
        switch self {
        case .editProfile: EditProfileView(account: AuthenticationService.authenticator.account ?? .emptyAccount)
        case .darkMode: DarkModeSettingsView()
        case .notifications: NotificationsSettingsView()
        case .activeStatus: ActiveStatusSettingsView()
        }
    }
    
    var id: Int { return self.rawValue}
}
