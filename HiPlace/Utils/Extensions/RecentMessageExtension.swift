//
//  RecentMessageExtension.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 22.06.2021.
//

import Foundation

extension RecentMessage {
    enum FieldName: CaseIterable {
        static let messageId = "messageId"
        static let fromUserUid = "fromUserUid"
        static let toUserUid = "toUserUid"
        static let message = "message"
        static let timestamp = "timestamp"
    }
    
    convenience init(fromUserUid: String, toUserUid: String, message: String, messageId: String, timestamp: Date) {
        self.init()
        self.messageId = messageId
        self.fromUserUid = fromUserUid
        self.toUserUid = toUserUid
        self.message = AGCCloudDBText.createText(message)
        self.timestamp = timestamp
    }
    
    func toMessage() -> Message {
        return Message(fromUserUid: fromUserUid, toUserUid: toUserUid, message: message.text, id: messageId, timestamp: timestamp)
    }
    
    open override var description: String {
        return "RecentMessage(" +
            "messageId: \(messageId), " +
            "fromUserUid: \(fromUserUid), " +
            "toUserUid: \(toUserUid), " +
            "message: \(message.text), " +
            "timestamp: \(timestamp.description)" +
            ")"
    }
}

