//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 26.12.24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

}

@main
struct ChatAppApp: App {
    @AppStorage("darkModeOption") private var selectedMode: DarkModeOption = .system
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var registrationViewModel = RegistrationViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(registrationViewModel)
                .preferredColorScheme(selectedMode.colorScheme)

        }
    }
}
