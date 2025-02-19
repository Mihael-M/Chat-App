//
//  ChatInboxViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//

import SwiftUI
import Firebase
import Combine

@MainActor
class ChatInboxViewModel : ObservableObject {
    @Published var currentUser: MyUser?
    @Published var conversations: [Conversation] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            setupSubscribers()
            await getData()
        }
    }
    
    private func setupSubscribers() {
        DataStorageService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        DataStorageService.shared.$conversations.sink { [weak self] conversations in
            self?.conversations = conversations
        }.store(in: &cancellables)
    }
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return self.conversations
        }
        return self.conversations.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    func getData() async {
        await DataStorageService.shared.getUsers()
        await DataStorageService.shared.getConversations()
    }

    func subscribeToUpdates() {
        DataStorageService.shared.subscribeToUpdates()
    }
}
