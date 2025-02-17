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
    
    private let authService = AuthenticationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        authService.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSession in
            self?.userSession = userSession
            print("Received new userSession: \(String(describing: self?.userSession))")
        }.store(in: &cancellables)
        
    }
}
