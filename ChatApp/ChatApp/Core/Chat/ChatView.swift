////
////  ChatView.swift
////  ChatApp
////
////  Created by Mishoni Mihaylov on 10.02.25.
////
//
//import SwiftUI
//
//struct ChatView: View {
//    @ObservedObject var viewModel: ChatViewModel
//    
//    var body: some View {
//        VStack {
//            // Messages list with auto-scroll to the latest message
//            ScrollViewReader { proxy in
//                ScrollView {
//                    LazyVStack(spacing: 8) {
//                        ForEach(viewModel.messages) { message in
//                            ChatMessageView(
//                                message: message,
//                                isCurrentUser: message.senderUsername == viewModel.currentUser
//                            )
//                            .id(message.id)
//                        }
//                    }
//                    .padding(.top)
//                }
//                .onChange(of: viewModel.messages) { _ in
//                    if let lastMessage = viewModel.messages.last {
//                        withAnimation {
//                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
//                        }
//                    }
//                }
//            }
//            
//            Divider()
//            
//            // Input area for composing and sending messages
//            HStack {
//                TextField("Type your message...", text: $viewModel.newMessage)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                Button(action: {
//                    viewModel.sendMessage()
//                }) {
//                    Image(systemName: "paperplane.fill")
//                        .rotationEffect(.degrees(45))
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Chat")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ChatView(viewModel: ChatViewModel())
//        }
//    }
//}
