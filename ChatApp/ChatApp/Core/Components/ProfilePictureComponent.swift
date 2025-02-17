//
//  ProfilePictureView.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 16.01.25.
//

import SwiftUI

enum ProfileImageSize {
    case xsmall
    case small
    case medium
    case large
    case xlarge
    
    var dimension: CGFloat {
        switch self {
        case .xsmall: return 32
        case .small: return 48
        case .medium: return 64
        case .large: return 80
        case .xlarge: return 200
        }
    }
}

struct ProfilePictureComponent: View {
    
    let user: MyUser?
    let size: ProfileImageSize
    var showActivityStatus: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let pictureURL = user?.profilePicture {
                Image(pictureURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
            } else {
                Image("picture")
                    .resizable()
                    .frame(width: size.dimension, height: size.dimension)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                        )
            }
            
            
            if showActivityStatus {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 0.25 * size.dimension, height: 0.25 * size.dimension)
                    if let activityStatus = user?.activityStatus {
                        Circle()
                            .fill(activityStatus ? Color(.systemGreen) : Color(.systemGray6))
                            .frame(width: 0.2 * size.dimension, height: 0.2 * size.dimension)
                    } else {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 0.2 * size.dimension, height: 0.2 * size.dimension)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfilePictureComponent(user: MyUser.emptyUser, size: .large)
    ProfilePictureComponent(user: MyUser.emptyUser, size: .large, showActivityStatus: true)
}
