//
//  SearchView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 26.01.25.
//

import SwiftUI
import ExyteChat

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = ChatInboxViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                // iMessage-style search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search messages...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: searchText) { _ in
                            Task {
                                await viewModel.fetchAllMessages()
                            }
                        }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 10)

                // Display messages
                ScrollView {
                    VStack {
                        if searchText.isEmpty {
                            Text("Search your messages")
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        } else {
                            ForEach(viewModel.searchMessage(searchText), id: \.id) { message in
                                MessageSearchResultRow(message: message, searchText: searchText)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(.black))
                    }
                }
            }

            .onAppear {
                Task {
                    await viewModel.fetchAllMessages()
                }
            }
        }
    }
}

//import SwiftUI
//import ExyteChat
//
//struct SearchView: View {
//    @State private var searchText = ""
//    @StateObject private var viewModel = ChatInboxViewModel()
//    @StateObject private var viewModelConversation = ConversationViewModel()
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Search Bar
//                TextField("Search messages...", text: $searchText)
//                    .padding(10)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//
//                // Display search results
//                ScrollView {
//                    VStack(spacing: 10) {
//                        ForEach(viewModel.searchMessage(searchText), id: \.id) { message in
//                            NavigationLink(destination: ConversationView(viewModel: viewModelConversation)) {
//                                HStack {
//                                    VStack(alignment: .leading) {
//                                        Text(message.text)
//                                            .font(.body)
//                                            .foregroundColor(.black)
//                                            .bold()
//                                        Text(formatTimestamp(message.createdAt))
//                                            .font(.footnote)
//                                            .foregroundColor(.gray)
//                                    }
//                                    Spacer()
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
//                                .padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Search")
//            .onAppear {
//                Task {
//                    await viewModel.fetchAllMessages()
//                }
//            }
//        }
//    }
//
//    func formatTimestamp(_ date: Date?) -> String {
//        guard let date = date else { return "" }
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//}
