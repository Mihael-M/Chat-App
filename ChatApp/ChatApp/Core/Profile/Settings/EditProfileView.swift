//
//  EditView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 13.01.25.
//

import SwiftUI

struct EditProfileView : View{
    @State private var username: String = ""
    @State private var phone_number: String = ""
    @State private var date_of_birth: Date = Date()
    
    @EnvironmentObject var chatManager: ChatManager
    
    
    var body: some View{
        VStack(alignment: .leading, spacing: 12) {
            CustomTextField(icon: "person.fill", prompt: "Username", value: $username)
            CustomTextField(icon: "phone.badge.plus.fill", prompt: "Phone", value: $phone_number)
                .keyboardType(.numberPad)
            DatePicker("Date of Birth:", selection: $date_of_birth, displayedComponents: .date)
                .datePickerStyle(.automatic)
                                   
        }
        .font(.body)
        .padding(.horizontal)
        
        Button{
            // Goes to profile view
        }
        label:{
            Text("Save")
        }
        .padding()
    }
    
}

#Preview {
    EditProfileView()
}
