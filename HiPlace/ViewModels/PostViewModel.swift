//
//  PostViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 17.06.2021.
//

import SwiftUI

class PostViewModel: ObservableObject {
    
    func fetchUser(uid: String, user: Binding<UserInfo?>)  {
        DispatchQueue.main.async {
            let query = AGCCloudDBQuery.where(UserInfo.classForCoder()).equal(to: uid, forField: UserInfo.FieldName.uid)
            CloudDBHelper.instance.query(query, UserInfo.self) { data, error in
                if let error = error {
                    print("DEBUG:: fetchUser for post: error: \(error.localizedDescription)")
                }
                if user.wrappedValue != nil {return}
                if let fetchedUser = data?.first {
                    DispatchQueue.main.async {
                        user.wrappedValue = fetchedUser
                    }
                }
            }
        }
    }
}
