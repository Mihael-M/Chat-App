//
//  DataStorageService.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 17.02.25.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class DataStorageService: ObservableObject {
    @Published var currentUser: MyUser?
    
    static var shared = DataStorageService()
    
    @MainActor
    func loadCurrentUserData() async throws {
        guard let currentUID = AuthenticationService.shared.userSession?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUID).getDocument()
        print("Snapshot data is \(snapshot.data())")
        self.currentUser = MyUser(dictionary: snapshot.data() ?? [:])
    }

    func loadAllUserData() async throws -> [MyUser] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ MyUser(dictionary: $0.data()) })
    }
}
