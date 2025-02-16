//
//  ProfilePictureView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

enum ProfileImageSize {
    case small
    case medium
    case large
    case xlarge
    
    var dimension: CGFloat {
        switch self {
        case .small: return 48
        case .medium: return 64
        case .large: return 80
        case .xlarge: return 200
        }
    }
}

struct ProfilePictureComponent: View {
    
    let pictureURL: String
    let size: ProfileImageSize
    var activityStatus: Bool = false
    var showActivityStatus: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(pictureURL)
                .resizable()
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                )
                .foregroundStyle(Color.secondary)
            
            if showActivityStatus {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(activityStatus ? Color(.systemGreen) : Color(.systemGray6))
                        .frame(width: 15, height: 15)
                }
            }
        }
    }
}

#Preview {
    ProfilePictureComponent(pictureURL: MyUser.emptyUser.profilePicture, size: .large)
    ProfilePictureComponent(pictureURL: MyUser.emptyUser.profilePicture, size: .large, activityStatus: true, showActivityStatus: true)
}
