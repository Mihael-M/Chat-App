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
    @Published var newUser: Bool = false
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthenticationService.authenticator.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
            print("change in user session \(self?.userSession)")
        }.store(in: &cancellables)
        
        AuthenticationService.authenticator.$newUser.receive(on: DispatchQueue.main).sink { [weak self] newUserStatus in
            self?.newUser = newUserStatus
            print("change in new user \(self?.newUser)")
        }.store(in: &cancellables)
        
        AuthenticationService.authenticator.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
            print("change in current user \(self?.currentUser)")
        }.store(in: &cancellables)
    }
    
}
