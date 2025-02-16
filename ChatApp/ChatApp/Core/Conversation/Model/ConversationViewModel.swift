//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 10.02.25.
//
//
import SwiftUI
import ExyteChat

class ConversationViewModel : ObservableObject {
    @Published var messages: [Message] = []
    
}
