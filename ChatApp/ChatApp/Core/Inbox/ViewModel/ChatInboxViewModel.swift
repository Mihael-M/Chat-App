//
//  ChatInboxViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//

import SwiftUI
import Firebase
import Combine

class ChatInboxViewModel : ObservableObject {
    @Published var currentUser: MyUser?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        DataStorageService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
