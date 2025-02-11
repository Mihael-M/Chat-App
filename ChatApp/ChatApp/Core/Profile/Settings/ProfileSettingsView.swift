//
//  ProfileSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var loggedOut = false
    var body: some View {
        VStack {
            ProfileHeaderView()
            List {
                Section {
                    ForEach(SettingOption.allCases, id: \.self) { option in
                        HStack {
                            NavigationLink(destination: option.destination , label: {
                                Image(systemName: option.imageName)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(option.imageBackgroundColor)
                                Text(option.title)
                            })
                        }
                    }
                }
                Section {
                    
                    Button(role: .destructive)
                    {
                        Task{
                            AuthenticationService.authenticator.signOut()
                            loggedOut.toggle()
                        }
                    }
                    label:{
                        Text("Log out")
                    }
                }
               
            }
        }
        .navigationDestination(isPresented: $loggedOut, destination: {ContentView()})
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink(
                    destination: {ChatHomePageView()},
                    label: {
                        Image(systemName: "chevron.left")
                })
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Your profile")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    ProfileSettingsView()
}
