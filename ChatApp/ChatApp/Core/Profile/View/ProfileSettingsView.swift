//
//  ProfileSettingsView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dataStorage = DataStorageService.shared
    var body: some View {
        VStack {
            //header
            ProfileHeaderView(user: dataStorage.currentUser ?? MyUser.emptyUser)
            
            //settings
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
                        AuthenticationService.shared.signOut()
                    }
                    label:{
                        Text("Log out")
                    }
                    
                }
                .foregroundStyle(Color(.red))
            }
        }
        .navigationTitle("Your profile")
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
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    NavigationStack {
        ProfileSettingsView()
    }
}
