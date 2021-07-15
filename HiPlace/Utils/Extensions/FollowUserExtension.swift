//
//  FollowUserExtension.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 16.06.2021.
//

import Foundation

extension FollowUser {
    enum FieldName: CaseIterable {
        static let followerUser = "followerUser"
        static let followingUser = "followingUser"
    }
    
    convenience init(followerUser: String, followingUser: String) {
        self.init()
        self.followerUser = followerUser
        self.followingUser = followingUser
    }
    
    open override var description: String {
        return "FollowUser(" +
                "followerUser: \(followerUser), " +
                "followingUser: \(followingUser)" +
                ")"
    }
}
