//
//  CustomButtonView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 8.01.25.
//

import SwiftUI

enum ButtonContent {
    case icon(name: String)
    case text(title: String)
}

struct CustomNavigatingButton<Destination : View> : View {
    
    let content: ButtonContent
    let action: () -> Void
    let destination: Destination
    var hideBackButton: Bool

    
    var body: some View {
        Button(action: action, label: {
            VStack {
               
                    NavigationLink{
                        destination.navigationBarBackButtonHidden(hideBackButton)
                    }
                    label:{
                        switch content {
                            case .icon(let name):
                            ZStack{
                                Circle()
                                    .fill(.blue)
                                    .frame(width:60, height: 60)
                            Image(systemName: name)
                                .font(.title3)
                                .foregroundStyle(.white)
                            }
                        case .text(let title):
                            Text(title)
                                .font(.callout)
                        }
                        
                    }
                    

            }
        })
        
    }
}

#Preview {
    //CustomButtonView()
}
