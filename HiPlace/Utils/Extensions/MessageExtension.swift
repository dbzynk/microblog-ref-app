//
//  MessageExtension.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 24.06.2021.
//

import Foundation

extension Message {
    enum FieldName: CaseIterable {
        static let id = "id"
        static let fromUserUid = "fromUserUid"
        static let toUserUid = "toUserUid"
        static let message = "message"
        static let timestamp = "timestamp"
    }
    
    convenience init(fromUserUid: String, toUserUid: String, message: String, id: String, timestamp: Date) {
        self.init()
        self.id = id
        self.fromUserUid = fromUserUid
        self.toUserUid = toUserUid
        self.message = AGCCloudDBText.createText(message)
        self.timestamp = timestamp
    }
    
    func toRecentMessage() -> RecentMessage {
        return RecentMessage(fromUserUid: fromUserUid, toUserUid: toUserUid, message: message.text, messageId: id, timestamp: timestamp)
    }
    
    func isFromCurrentUser() -> Bool {
        return fromUserUid == AuthService.shared.userSession?.uid
    }
    
    open override var description: String {
        return "Message(" +
            "id: \(id), " +
            "fromUserUid: \(fromUserUid), " +
            "toUserUid: \(toUserUid), " +
            "message: \(message.text), " +
            "timestamp: \(timestamp.description)" +
            ")"
    }
}
