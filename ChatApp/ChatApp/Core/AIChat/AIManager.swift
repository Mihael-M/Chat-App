//
//  AIManager.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 19.02.25.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import ExyteOpenAI

final class AIManager {
    static let shared = AIManager()
    
    private let apiKey: String = ""
    private let assistantId: String = ""
    
    private let client: OpenAI
    private var threadId: String = ""
    private var didReceiveResponse: ((String, String) -> ())?
    
    private var subscriptions = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    
    private init() {  
           guard !apiKey.isEmpty else {
               fatalError("Empty OpenAI API key")
           }
           guard !assistantId.isEmpty else {
               fatalError("Empty Assistant ID")
           }
           client = OpenAI(apiKey: apiKey)
           fetchThreadID()
       }
    
    func getBotResponse(_ messageText: String) async -> (String, String) {
        await withCheckedContinuation { continuation in
            didReceiveResponse = { id, text in
                continuation.resume(returning: (id, text))
                self.didReceiveResponse = nil
            }
            sendMessage(messageText, fileID: nil)
        }
    }
    
    private func fetchThreadID() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error retrieving thread ID: \(error)")
                self?.createThread()
                return
            }

            if let document = document, document.exists,
               let storedThreadId = document.data()?["thread_id"] as? String, !storedThreadId.isEmpty {
                self?.threadId = storedThreadId
            } else {
                self?.createThread()
            }
        }
    }
    
    private func createThread() {
        let createThreadPayload = CreateThreadPayload(messages: [], metadata: [:])
        client.createThread(from: createThreadPayload)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        debugPrint(error)
                    }
                },
                receiveValue: { [weak self] thread in
                    self?.threadId = thread.id
                    self?.saveThreadToFirebase(thread.id)
                }
            )
            .store(in: &subscriptions)
    }
    
    private func saveThreadToFirebase(_ threadId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData(["thread_id": threadId]) { error in
            if let error = error {
                print("Error saving thread ID: \(error)")
            } else {
                print("Thread ID saved successfully.")
            }
        }
    }
    
    private func sendMessage(_ messageText: String, fileID: String?) {
        let createMessagePayload = CreateMessagePayload(role: .user, content: messageText)
        client.createMessage(in: threadId, payload: createMessagePayload)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        debugPrint(error)
                    }
                },
                receiveValue: { [weak self] message in
                    self?.createRun(lastMessageId: message.id)
                }
            )
            .store(in: &subscriptions)
    }
    
    private func createRun(lastMessageId: String) {
        let runPayload = CreateRunPayload(assistantId: assistantId)
        client.createRun(in: threadId, payload: runPayload)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        debugPrint(error)
                    }
                },
                receiveValue: { [weak self] run in
                    self?.checkRunStatus(runId: run.id, lastMessageId: lastMessageId)
                }
            )
            .store(in: &subscriptions)
    }
    
    private func checkRunStatus(runId: String, lastMessageId: String) {
        client.retrieveRun(id: runId, from: threadId)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        debugPrint(error)
                    }
                },
                receiveValue: { [weak self] run in
                    if run.status != .completed {
                        usleep(300)
                        self?.checkRunStatus(runId: runId, lastMessageId: lastMessageId)
                    } else {
                        self?.fetchResponse(lastMessageId: lastMessageId)
                    }
                }
            )
            .store(in: &subscriptions)
    }
    
    private func fetchResponse(lastMessageId: String) {
        let listPayload = ListPayload(limit: 1, order: .asc, after: lastMessageId)
        client.listMessages(from: threadId, payload: listPayload)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        debugPrint(error)
                    }
                },
                receiveValue: { [weak self] list in
                    guard let message = list.data.first,
                          let textContent = message.content.first?.text?.value else { return }
                    self?.didReceiveResponse?(message.id, textContent)
                }
            )
            .store(in: &subscriptions)
    }
}
