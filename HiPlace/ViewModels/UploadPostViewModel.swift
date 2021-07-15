//
//  UploadPostViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 17.06.2021.
//

import Foundation

class UploadPostViewModel: ObservableObject {
    
    func uploadPost(text: String, completion: @escaping (Error?) -> Void) {
        guard let uid = AuthService.shared.userSession?.uid else {return}
        let post = Post()
        post.id = UUID().uuidString
        post.userUid = uid
        post.caption = AGCCloudDBText.createText(text)
        post.likeCount = NSNumber(0)
        post.timeStamp = Date()
        
        CloudDBHelper.instance.upsertOne(data: post, completion: completion)
    }
}
