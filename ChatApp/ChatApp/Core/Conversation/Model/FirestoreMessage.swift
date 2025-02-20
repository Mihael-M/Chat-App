//
//  FirestoreMessage.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 18.02.25.
//
import Foundation
import FirebaseFirestore
import ExyteChat

public struct FirestoreMessage: Codable, Hashable {

    @DocumentID public var id: String?
    public var userId: String
    @ServerTimestamp public var createdAt: Date?

    public var text: String
    public var attachments: [FirestoreAttachment]
    public var recording: FirestoreRecording?
    public var replyMessage: FirestoreReply?
}

public struct FirestoreAttachment: Codable, Hashable {

    public let thumbURL: String
    public let url: String
    public let type: AttachmentType
}

public struct FirestoreReply: Codable, Hashable {

    @DocumentID public var id: String?
    public var userId: String
    @ServerTimestamp public var createdAt: Date?

    public var text: String
    public var attachments: [FirestoreAttachment]
    public var recording: FirestoreRecording?
}

public struct FirestoreRecording: Codable, Hashable {
    public var duration: CGFloat
    public var waveformSamples: [CGFloat]
    public var url: String
}

extension FirestoreMessage {
    func toMessage(users: [MyUser]) -> Message? {
        guard let id = self.id,
              let date = self.createdAt,
              let user = users.first(where: { $0.id == self.userId }) else { return nil }

        let convertAttachments: ([FirestoreAttachment]) -> [Attachment] = { attachments in
            attachments.compactMap {
                if let thumbURL = URL(string: $0.thumbURL), let url = URL(string: $0.url) {
                    return Attachment(id: UUID().uuidString, thumbnail: thumbURL, full: url, type: $0.type)
                }
                return nil
            }
        }

        let convertRecording: (FirestoreRecording?) -> Recording? = { recording in
            if let recording = recording {
                return Recording(duration: recording.duration, waveformSamples: recording.waveformSamples, url: URL(string: recording.url))
            }
            return nil
        }

        var replyMessage: ReplyMessage?
        if let reply = self.replyMessage,
           let replyId = reply.id,
           let replyCreatedAt = reply.createdAt,
           let replyUser = users.first(where: { $0.id == reply.userId }) {
            replyMessage = ReplyMessage(
                id: replyId,
                user: replyUser.base,
                createdAt: replyCreatedAt,
                text: reply.text,
                attachments: convertAttachments(reply.attachments),
                recording: convertRecording(reply.recording))
        }

        return Message(
            id: id,
            user: user.base,
            status: .sent,
            createdAt: date,
            text: self.text,
            attachments: convertAttachments(self.attachments),
            recording: convertRecording(self.recording),
            replyMessage: replyMessage
        )
    }
}
