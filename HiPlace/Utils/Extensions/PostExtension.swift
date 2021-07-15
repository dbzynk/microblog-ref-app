//
//  PostExtension.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 17.06.2021.
//

import Foundation

extension Post {
    enum FieldName: CaseIterable {
        static let id = "id"
        static let userUid = "userUid"
        static let caption = "caption"
        static let likeCount = "likeCount"
        static let timeStamp = "timeStamp"
    }
    convenience init(id: String?=nil, userUid: String?=nil, caption:String?=nil, likeCount: Int?=nil, timeStamp: Date?=nil)  {
        self.init()
        if let id = id { self.id = id }
        if let userUid = userUid { self.userUid = userUid }
        if let caption = caption { self.caption = AGCCloudDBText.createText(caption) }
        if let likeCount = likeCount { self.likeCount = NSNumber(value: likeCount) }
        if let timeStamp = timeStamp { self.timeStamp = timeStamp }
    }
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeStamp, to: Date()) ?? ""
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · dd/MM/yyyy"
        return formatter.string(from: timeStamp)
    }
}
