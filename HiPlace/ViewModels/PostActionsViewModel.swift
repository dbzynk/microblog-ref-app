//
//  PostActionsViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 21.06.2021.
//

import Foundation

class PostActionsViewModel: ObservableObject {
    let post: Post
    @Published var didLike = false
    
    init(post: Post) {
        self.post = post
        checkIfUserLikedPost()
    }
    
    func likePost()  {
        guard let uid = AuthService.shared.userSession?.uid else {return}
        let likePost = LikePost(userUid: uid, postId: self.post.id)
        CloudDBHelper.instance.upsertOne(data: likePost) { error in
            if let error = error {
                print("DEBUG: PostActionsViewModel likePost Error: \(error.localizedDescription)")
                return
            }
            self.post.likeCount = NSNumber(value: self.post.likeCount.intValue + 1)
            
            CloudDBHelper.instance.upsertOne(data: self.post) { error in
                if let error = error {
                    print("DEBUG: PostActionsViewModel likePost upsert on the post Error: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.didLike = true
                }
            }
        }
    
    }
    
    func unlikePost() {
        guard let uid = AuthService.shared.userSession?.uid else {return}
        let likePost = LikePost(userUid: uid, postId: self.post.id)
        self.post.likeCount = NSNumber(value: self.post.likeCount.intValue - 1)
        if self.post.likeCount.intValue < 0 {
            self.post.likeCount = NSNumber(value: 0)
        }
        CloudDBHelper.instance.upsertOne(data: self.post) { error in
            if let error = error {
                print("DEBUG: PostActionsViewModel unlikePost upsert on post Error: \(error.localizedDescription)")
                return
            }
            
            CloudDBHelper.instance.deleteOne(data: likePost) { _, error in
                if let error = error {
                    print("DEBUG: PostActionsViewModel unlikePost Error: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.didLike = false
                }
            }
        }
        
    }
    
    func checkIfUserLikedPost() {
        guard let uid = AuthService.shared.userSession?.uid else {return}
        
        let query = AGCCloudDBQuery.where(LikePost.classForCoder())
            .equal(to: uid, forField: LikePost.FieldName.userUid)
            .equal(to: post.id, forField: LikePost.FieldName.postId)
        
        CloudDBHelper.instance.getCount(query: query, fieldName: LikePost.FieldName.userUid) { count, error in
            if let error = error {
                print("DEBUG: checkIfUserLikedPost Error: \(error.localizedDescription)")
                return
            }

            if let count = count, count > 0, !self.didLike {
                DispatchQueue.main.async { self.didLike = true }
            }
        }
    }
}
