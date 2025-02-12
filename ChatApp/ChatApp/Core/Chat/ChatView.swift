////
////  ChatView.swift
////  ChatApp
////
////  Created by Mishoni Mihaylov on 10.02.25.
////
//
//import SwiftUI
//import ExyteChat
//
//struct ConversationView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var viewModel = ConversationViewModel()
//    
//    var body: some View {
//        NavigationStack {
//            ChatView(messages: viewModel.messages) { draft in
//                viewModel.sendMessage(draft.text)
//            }
//            // Media picker theme (customize the colors as needed)
//            .mediaPickerTheme(
//                main: .init(
//                    text: .white,
//                    albumSelectionBackground: Color.gray.opacity(0.5),
//                    fullscreenPhotoBackground: Color.gray.opacity(0.5)
//                ),
//                selection: .init(
//                    emptyTint: .white,
//                    emptyBackground: Color.black.opacity(0.25),
//                    selectedTint: .blue,
//                    fullscreenTint: .white
//                )
//            )
//            .onDisappear {
//                viewModel.resetUnreadCounter()
//            }
//            .navigationBarBackButtonHidden()
//            .toolbar {
//                ToolbarItem(placement: .navigation) {
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                    }
//                }
//                ToolbarItem(placement: .principal) {
//                    Text("Conversation")
//                        .font(.headline)
//                }
//            }
//            .navigationTitle("Conversation")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//
//
//// MARK: - Previews
//
//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationView()
//    }
//}
