//
//  LikePostExtension.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 21.06.2021.
//

import Foundation

extension LikePost {
    enum FieldName: CaseIterable {
        static let postId = "postId"
        static let userUid = "userUid"
    }
    
    convenience init(userUid: String?=nil, postId: String?=nil)  {
        self.init()
        if let postId = postId { self.postId = postId }
        if let userUid = userUid { self.userUid = userUid }
    }
}
