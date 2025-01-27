//
//  ContentViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 15.01.25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

class ContentViewModel : ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthenticationService.authenticator.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellables)
        
        AuthenticationService.authenticator.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }.store(in: &cancellables)
    }
    
}
