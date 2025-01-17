//
//  EmailVerificationView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 17.01.25.
//

import SwiftUI

struct EmailVerificationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    private func verifyEmail(){
        Task{
            do{
                try await viewModel.verifyEmail()
                dismiss()
            }
            catch{
                print ("Error verifying email: \(error.localizedDescription)")
            }
        }
    }
    var body: some View {
        VStack(spacing: 20){
            Text("Email verification link sent")
                .font(.headline)
                .padding()
                .bold()
            Text("Click the link to proceed")
                .font(.subheadline)
        }
        .onAppear{
            verifyEmail()
        }
    }
       
}

#Preview {
    EmailVerificationView()
}
