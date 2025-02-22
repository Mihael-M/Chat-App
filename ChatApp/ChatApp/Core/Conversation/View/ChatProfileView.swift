//
//  ChatProfileView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 21.02.25.
//

import SwiftUI

struct ChatProfileView: View {
    @Binding var isPresented: Bool
    @State private var dragOffset: CGFloat = 0
    
    let user: MyUser
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            ProfileHeaderView(user: user)
            
            Button{
                withAnimation {
                    isPresented = false
                }
            }
        label:
            {
                Capsule()
                    .frame(width: 50, height: 5)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
            }
            .padding()
            Spacer()
                .frame(maxHeight:5)
        }
        .contentShape(Rectangle())
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .cornerRadius(20)
        .shadow(radius: 10)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height < 0 { // Swiping up
                        dragOffset = gesture.translation.height
                    }
                }
                .onEnded { _ in
                    if dragOffset < -100 { // If swiped up far enough, close it
                        withAnimation {
                            isPresented = false
                        }
                    }
                    dragOffset = 100 // Reset drag offset
                }
        )
    }
}

#Preview {
    ChatProfileView(isPresented: .constant(true), user: MyUser.aiUser)
}
