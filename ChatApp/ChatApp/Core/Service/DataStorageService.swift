//
//  DataStorageService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//
import SwiftUI

class DataStorageService: ObservableObject {
    static var shared = DataStorageService()
    
    func updateUserData(uid: String, data: [String: Any]) async throws {
//        try await Firestore.firestore().collection("users").document(userSession!.uid).updateData(data)
    }
    

    func loadUserData() async throws {
//        self.userSession = Auth.auth().currentUser
//        guard let currentUID = userSession?.uid else { return }
//        let snapshot = try await Firestore.firestore().collection("users").document(currentUID).getDocument()
//        self.currentUser = try? snapshot.data(as: MyUser.self)
    }
}
