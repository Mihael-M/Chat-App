//
//  ChatHomePageView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

struct ChatHomePageView: View {
    @EnvironmentObject var chatManager : ChatManager
    @State private var visible : Bool = false
    @State private var offset : CGFloat = 0
    @State private var showAddChatView : Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                Divider()
                Spacer()
                List()
                {
                    
                }
                Spacer()
                Button(action: {
                    visible = true
                    showAddChatView.toggle()
                    withAnimation(.easeInOut(duration : 0.3)){
                        offset = offset == 600 ? 0 : 600
                    }
                   
                }) {
                    Image(systemName: "plus")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .sheet(isPresented: $showAddChatView, content: {
                AddChatView()
                    .presentationDetents([.height(400)])
            })
        }
        .navigationTitle("Our App Name :)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button(action: {
                    
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                        
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                        
                }
                
            }
                
        }
    }
}

#Preview {
    ChatHomePageView()
}
