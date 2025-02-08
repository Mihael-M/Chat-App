//
//  EmailVerificationView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 17.01.25.
//

import SwiftUI
//-----------------------------------------------//

//Need paid apple developer account to use..

//-----------------------------------------------//
struct EmailVerificationView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss

    private func verifyEmail(url: URL) {
        Task {
            do {
                AuthenticationService.authenticator.emailLink = url.absoluteString
                try await viewModel.verifyEmail()
                if viewModel.emailVerified {
                    dismiss()
                }
            } catch {
                print("Error verifying email: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Email verification link sent")
                .font(.headline)
                .padding()
                .bold()
            Text("Click the link to proceed")
                .font(.subheadline)
        }
        .onOpenURL { url in
            verifyEmail(url: url)
        }
    }
}

//#Preview {
//    EmailVerificationView(viewModel: )
//}
