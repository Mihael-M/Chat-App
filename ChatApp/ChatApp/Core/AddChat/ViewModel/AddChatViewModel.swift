//
//  AddChatViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//
import SwiftUI

@MainActor
class AddChatViewModel: ObservableObject {
    @Published var users = [MyUser]()
    
    init(){
        Task {
            try await loadOtherUsers()
        }
    }
    
    func loadOtherUsers() async throws {
        guard let currentUID = DataStorageService.shared.currentUser?.id else { return }
        let allUsers = try await DataStorageService.shared.loadAllUserData()
        self.users = allUsers.filter { $0.id != currentUID }
    }
}
