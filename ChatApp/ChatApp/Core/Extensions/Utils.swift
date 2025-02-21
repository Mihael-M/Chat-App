//
//  Utils.swift
//  ChatApp
//
//  Created by Mishoni Mihaylov on 12.02.25.
//

import Foundation
import FirebaseFirestore

extension DataStorageService {
    func getAIUser() async -> MyUser? {
        let aiUserId = "AI_Bot"
        let userRef = Firestore.firestore().collection("users").document(aiUserId)

        do {
            let document = try await userRef.getDocument()
            if let data = document.data() {
                return MyUser(dictionary: data, isCurrentUser: false)
            }
        } catch {
            print("❌ Error fetching AI User: \(error)")
        }
        return nil
    }
}

extension DataStorageService {
    func ensureAIUserExists() async {
        let aiUserId = "AI_Bot" // Fixed ID for AI Assistant
        let userRef = Firestore.firestore().collection("users").document(aiUserId)

        do {
            let document = try await userRef.getDocument()
            if !document.exists { 
                let aiUserData: [String: Any] = [
                    "uid": aiUserId,
                    "username": "AI Assistant",
                    "email": "ai@assistant.com",
                    "nickname": "AI Assistant",
                    "phone_number": "N/A",
                    "date_of_birth": Timestamp(date: Date(timeIntervalSince1970: 0)),
                    "activityStatus": true,
                    "avatarURL": "https://firebasestorage.googleapis.com/v0/b/swiftuicoursechatapp.firebasestorage.app/o/aibotavatar.png?alt=media&token=fd7d5401-9b94-4b49-85d2-ed6cc521b3e2",
                    "messagesSent": 0,
                    "messagesReceived": 0
                ]
                try await userRef.setData(aiUserData)
                print("✅ AI User added to Firestore.")
            } else {
                print("✅ AI User already exists.")
            }
        } catch {
            print("❌ Error checking/creating AI User: \(error)")
        }
    }
}

extension Date {
    func timeAgoFormat(numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let date = self
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else {
            return "Just now"
        }
    }
}
