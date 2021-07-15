//
//  UserInfoExtension.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 16.06.2021.
//

import Foundation

extension UserInfo {
    enum FieldName: CaseIterable {
        static let email = "email"
        static let uid = "uid"
        static let fullName = "fullName"
        static let username = "username"
        static let profileImageUrl = "profileImageUrl"
    }

    convenience init(uid: String?=nil, email: String?=nil, fullName: String?=nil, username:  String?=nil, profileImageUrl:  String?=nil)  {
        self.init()
        
        if let uid = uid { self.uid = uid }
        if let email = email { self.uid = email }
        if let fullName = fullName { self.fullName = fullName }
        if let username = username { self.username = username }
        if let profileImageUrl = profileImageUrl { self.profileImageUrl = profileImageUrl }
    }
    
    var isCurrentUser: Bool {
        return AuthService.shared.userSession?.uid == self.uid
    }
    
    open override var description: String {
        return "UserInfo(" +
            "uid: \(uid), " +
            "email: \(email), " +
            "fullName: \(fullName), " +
            "username: \(username), " +
            "profileImageUrl: \(profileImageUrl)" +
            ")"
    }
       
//    var followingCountString: String? {
//        return MyClassObjectiveC.convert(toString: followingCount)
//    }
//    var followersCountString: String? {
//        return MyClassObjectiveC.convert(toString: followersCount)
//    }
}
