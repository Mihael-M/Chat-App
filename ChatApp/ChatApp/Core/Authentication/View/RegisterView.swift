//
//  RegisterView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct RegisterView : View{
    @StateObject var viewModel = RegistrationViewModel()
    
    @State private var showRegisterAlert = false
    @State private var isPressed = false
    var body: some View {
        
        VStack(alignment: .center, spacing: 15){
            
            Spacer()
            
            Text("Our App Name 🌟")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                
                CustomTextField(icon: "at", prompt: "Email", value: $viewModel.email)
                Text("Must be valid email")
                    .font(.footnote)
                    .foregroundStyle(.red)
                
                CustomTextField(icon: "key", prompt: "Password", value: $viewModel.password)
                Text("Must be at least 8 characters")
                    .font(.footnote)
                    .foregroundStyle(.red)
                
                
            }
            .font(.body)
            .padding(.horizontal)
            Button(action:{
                Task{ try await viewModel.register() }
                showRegisterAlert = true
            })
            {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
                    .animation(.spring(), value: isPressed)
            }
            .onTapGesture {
                isPressed.toggle()
            }
            
            Spacer()
            
            NavigationLink {
                LogInView()
            } label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width:60, height: 60)
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animation(.spring(), value: isPressed)
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
            .onTapGesture {
                isPressed.toggle()
            }
            
            Text("Already have an account?")
                .font(.callout)
            
//            Button(action:{
//            })
//            {
//                NavigationLink("Already have an account", destination: LogInView())
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding(.vertical, 12)
//                    .padding(.horizontal, 24)
//                    .background(
//                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
//                    )
//                    .cornerRadius(25)
//                    .shadow(radius: 10)
//                    .scaleEffect(isPressed ? 0.98 : 1.0)
//                    .animation(.spring(), value: isPressed)
//            }
//            .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
//                isPressed = pressing
//            }, perform: {})
        }
        .padding()
        .alert(isPresented: $showRegisterAlert) {
            Alert(
                title: Text("Registered succesfully!"),
                message: Text("You can now edit your profile"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden()
        
    }
    
}


#Preview {
    RegisterView()
}
