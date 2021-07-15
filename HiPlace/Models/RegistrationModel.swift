//
//  RegistrationModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 6.06.2021.
//

import Foundation

struct RegistrationModel {
     var fullName: String = ""
     var email: String = ""
     var username: String = ""
     var password: String = ""
    
    func toUserInfo() -> UserInfo {
        let userInfo = UserInfo()
        userInfo.email = email
        userInfo.username = username
        userInfo.fullName = fullName
        userInfo.profileImageUrl = ""
        userInfo.uid = ""
        return userInfo
    }
}
