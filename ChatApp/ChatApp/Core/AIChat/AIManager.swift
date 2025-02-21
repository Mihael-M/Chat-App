import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import ExyteOpenAI

final class AIManager {
    static let shared = AIManager()
    
    
    //          need to secure before push!!!               //
    private let apiKey: String = ""
    private let assistantId: String = ""
    
    private let client: OpenAI
    private var threadId: String = ""
    private var didReceiveResponse: ((String, String) -> ())?
    
    private var subscriptions = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    
    private init() {
        guard !apiKey.isEmpty else {
            fatalError("❌ ERROR: OpenAI API key is missing!")
        }
        guard !assistantId.isEmpty else {
            fatalError("❌ ERROR: Assistant ID is missing!")
        }
        print("✅ AIManager initialized with API Key and Assistant ID.")
        client = OpenAI(apiKey: apiKey)
        fetchThreadID()
    }
    
    func getBotResponse(_ messageText: String) async -> (String, String) {
        print("📩 Sending user message: \(messageText)")
        return await withCheckedContinuation { continuation in
            didReceiveResponse = { id, text in
                print("✅ AI response received: \(text)")
                continuation.resume(returning: (id, text))
                self.didReceiveResponse = nil
            }
            sendMessage(messageText, fileID: nil)
        }
    }
    
    private func fetchThreadID() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ ERROR: No authenticated user found!")
            return
        }
        
        print("🔍 Checking for existing thread ID for user: \(userId)")
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("❌ ERROR retrieving thread ID: \(error)")
                self?.createThread()
                return
            }

            if let document = document, document.exists,
               let storedThreadId = document.data()?["thread_id"] as? String, !storedThreadId.isEmpty {
                print("✅ Found existing thread ID: \(storedThreadId)")
                self?.threadId = storedThreadId
            } else {
                print("⚠️ No existing thread ID found. Creating a new thread...")
                self?.createThread()
            }
        }
    }
    
    private func createThread() {
        print("🆕 Creating new thread...")
        let createThreadPayload = CreateThreadPayload(messages: [], metadata: [:])
        client.createThread(from: createThreadPayload)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("❌ ERROR creating thread: \(error)")
                    }
                },
                receiveValue: { [weak self] thread in
                    self?.threadId = thread.id
                    print("✅ Thread created with ID: \(thread.id)")
                    self?.saveThreadToFirebase(thread.id)
                }
            )
            .store(in: &subscriptions)
    }
    
    private func saveThreadToFirebase(_ threadId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        print("💾 Saving thread ID to Firestore for user: \(userId)")
        db.collection("users").document(userId).updateData(["thread_id": threadId]) { error in
            if let error = error {
                print("❌ ERROR saving thread ID: \(error)")
            } else {
                print("✅ Thread ID saved successfully.")
            }
        }
    }
    
    private func sendMessage(_ messageText: String, fileID: String?) {
        print("📨 Sending message to AI: \(messageText)")
        let createMessagePayload = CreateMessagePayload(role: .user, content: messageText)
        client.createMessage(in: threadId, payload: createMessagePayload)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("❌ ERROR sending message: \(error)")
                    }
                },
                receiveValue: { [weak self] message in
                    print("✅ Message sent successfully with ID: \(message.id)")
                    self?.createRun(lastMessageId: message.id)
                }
            )
            .store(in: &subscriptions)
    }
    
    private func createRun(lastMessageId: String) {
        print("▶️ Starting AI processing for message ID: \(lastMessageId)")
        let runPayload = CreateRunPayload(assistantId: assistantId)
        client.createRun(in: threadId, payload: runPayload)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("❌ ERROR creating AI run: \(error)")
                    }
                },
                receiveValue: { [weak self] run in
                    print("✅ AI run started with ID: \(run.id)")
                    self?.checkRunStatus(runId: run.id, lastMessageId: lastMessageId)
                }
            )
            .store(in: &subscriptions)
    }
    
    private func checkRunStatus(runId: String, lastMessageId: String) {
        print("🔄 Checking AI run status for ID: \(runId)")
        client.retrieveRun(id: runId, from: threadId)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("❌ ERROR checking AI run status: \(error)")
                    }
                },
                receiveValue: { [weak self] run in
                    if run.status != .completed {
                        print("⏳ AI run not completed yet. Retrying...")
                        usleep(300)
                        self?.checkRunStatus(runId: runId, lastMessageId: lastMessageId)
                    } else {
                        print("✅ AI run completed. Fetching response...")
                        self?.fetchResponse(lastMessageId: lastMessageId)
                    }
                }
            )
            .store(in: &subscriptions)
    }
    
    private func fetchResponse(lastMessageId: String) {
        print("📥 Fetching AI response for message ID: \(lastMessageId)")
        let listPayload = ListPayload(limit: 1, order: .asc, after: lastMessageId)
        client.listMessages(from: threadId, payload: listPayload)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("❌ ERROR fetching AI response: \(error)")
                    }
                },
                receiveValue: { [weak self] list in
                    guard let message = list.data.first,
                          let textContent = message.content.first?.text?.value else {
                        print("❌ ERROR: No AI response received!")
                        return
                    }
                    print("✅ AI Response Received: \(textContent)")
                    self?.didReceiveResponse?(message.id, textContent)
                }
            )
            .store(in: &subscriptions)
    }
}
