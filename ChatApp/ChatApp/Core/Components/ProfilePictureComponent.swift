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
    let conversation: Conversation?
    let size: ProfileImageSize
    var showActivityStatus: Bool = false
    
    init(user: MyUser?, size: ProfileImageSize, showActivityStatus: Bool = false) {
        self.user = user
        self.conversation = nil
        self.size = size
        self.showActivityStatus = showActivityStatus
    }
    
    init(conversation: Conversation?, size: ProfileImageSize) {
        self.user = nil
        self.conversation = conversation
        self.size = size
        self.showActivityStatus = false
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            image
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                )
            
            
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
    @ViewBuilder
    private var image: some View {
        if let user = user, let url = user.base.avatarURL {
            AsynchronousImage(url: url, size: self.size)
        } else if let conversation = conversation {
            if conversation.isGroup {
                AsynchronousImage(url: conversation.pictureURL, size: self.size)
            } else {
                let url = conversation.users.first(where: { $0.id != DataStorageService.currentUserID})!.base.avatarURL
                AsynchronousImage(url: url, size: self.size)
            }
        } else {
            Image("defaultavatar").resizable()
        }
    }
}

struct AsynchronousImage : View {
    @State var url: URL?
    @State var size: ProfileImageSize
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size.dimension, height: size.dimension)
            case .success(let image):
                image.resizable()
            case .failure:
                Image("defaultavatar").resizable()
            @unknown default:
                Image("defaultavatar").resizable()
            }
        }
    }
}

#Preview {
    ProfilePictureComponent(user: MyUser.emptyUser, size: .large)
    ProfilePictureComponent(user: MyUser.emptyUser, size: .large, showActivityStatus: true)
}
