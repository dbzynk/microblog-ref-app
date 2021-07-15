//
//  ProfileViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 15.06.2021.
//

import Foundation
import AGConnectFunction

struct UserStats {
    var followersCount: String
    var followingCount: String
}

class ProfileViewModel: ObservableObject {

    @Published var isFollowed = false
    var user: UserInfo
    @Published var userStats = UserStats(followersCount: "-", followingCount: "-")
    
    @Published var userPosts = [Post]()
    @Published var likedPosts = [Post]()
    
    init(user: UserInfo) {
        self.user = user
        getUserDetail()
        fetchUserPosts()
        fetchLikedPosts()
    }
    
    func getUserDetail() {
        guard let currentUser = AuthService.shared.userSession else {return}
        let dict = ["currentUserUid": currentUser.uid, "profileUserUid": self.user.uid]
        
        CloudFunctions.shared.call(httpTriggerUri: CloudFunctions.FETCH_PROFILE_USER_DETAILS, with: dict) { [weak self] task in
            guard task.isSuccessful else {
                print("CloudFunctions:: task is not successful, using CloudDB to retrieve data")
                self?.checkIfUserIsFollowed()
                self?.fetchUserStats()
                return
            }
            
            guard let data = (task.result?.value())?.data(using: .utf8) else { return }
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let isUserFollowed = dict?["isUserFollowed"] as? Bool else { return }
            guard let followersCount = dict?["followersCount"] as? String else { return }
            guard let followingCount = dict?["followingCount"] as? String else { return }
            
            DispatchQueue.main.async {
                self?.isFollowed = isUserFollowed
                self?.userStats.followersCount = followersCount
                self?.userStats.followingCount = followingCount
            }
            
        } onFailure: { [weak self] error in
            print("CloudFunctions:: error: \(error.localizedDescription)")
            self?.checkIfUserIsFollowed()
            self?.fetchUserStats()
        }
        
    }
    
    func follow() {
        DispatchQueue.main.async {
            guard let currentUser = AuthService.shared.userSession else {return}
            
            AGConnectCloudDB.shareInstance().openZone2(CloudDBHelper.instance.getZoneConfig(), allowCreate: true) { dbZone, error in
                if let error = error {
                    print("DEBUG: follow Error: \(error.localizedDescription)")
                    return
                }
                
                let follow = FollowUser(followerUser: currentUser.uid, followingUser: self.user.uid)
                dbZone?.executeUpsertOne(follow, onCompleted: { result, error in
                    
                    if let error = error {
                        print("DEBUG:: follow executeUpsertOne: error: \(error.localizedDescription)")
                        return
                    }
                    print("DEBUG:: Follow successful!")
                    DispatchQueue.main.async {
                        self.fetchUserStats()
                        self.isFollowed = true
                    }
                })
            }
            
        }
    }
    
    func unfollow() {
        DispatchQueue.main.async {
            guard let currentUser = AuthService.shared.userSession else {return}

            AGConnectCloudDB.shareInstance().openZone2(CloudDBHelper.instance.getZoneConfig(), allowCreate: true) { dbZone, error in
                if let error = error {
                    print("DEBUG: unfollow Error: \(error.localizedDescription)")
                    return
                }
                
                let follow = FollowUser(followerUser: currentUser.uid, followingUser: self.user.uid)
                dbZone?.executeDeleteOne(follow, onCompleted: { result, error in
                    
                    if let error = error {
                        print("DEBUG:: unfollow executeUpsertOne: error: \(error.localizedDescription)")
                        return
                    }
                    print("DEBUG:: Unfollow successful!")
                    DispatchQueue.main.async {
                        self.fetchUserStats()
                        self.isFollowed = false
                    }
                })
            }
        }
    }
    
    func checkIfUserIsFollowed() {
        DispatchQueue.main.async {
            guard let currentUser = AuthService.shared.userSession else {return}

            let query = AGCCloudDBQuery.where(FollowUser.classForCoder())
                .equal(to: currentUser.uid, forField: FollowUser.FieldName.followerUser)
                .equal(to: self.user.uid, forField: FollowUser.FieldName.followingUser)
            
            CloudDBHelper.instance.query(query, FollowUser.self) { snapshotObjects, error in
                if let error = error {
                    print("DEBUG:: checkIfUserIsFollowed: error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.isFollowed = snapshotObjects?.first != nil ? true : false
                }
            }
        }
    }
    
    func fetchUserStats() {
        fetchCount(fieldName: FollowUser.FieldName.followerUser) { count,_ in
            if let count = count {
                DispatchQueue.main.async {
                    self.userStats.followingCount = String(count)
                }
            }
        }
        fetchCount(fieldName: FollowUser.FieldName.followingUser) { count,_ in
            if let count = count {
                DispatchQueue.main.async {
                    self.userStats.followersCount = String(count)
                }
            }
        }
    }
    
    func fetchCount(fieldName: String, completion: @escaping (Int?, Error?) -> Void) {
        let query = AGCCloudDBQuery.where(FollowUser.classForCoder())
            .equal(to: self.user.uid, forField: fieldName)

        CloudDBHelper.instance.getCount(query: query, fieldName: fieldName) { count, error in
            if let error = error {
                print("DEBUG:: fetchCount: fieldName: '\(fieldName)' error: \(error.localizedDescription)")
            }
            completion(count, error)
        }
    }
    
    func fetchUserPosts() {
        DispatchQueue.main.async {
            let query = AGCCloudDBQuery.where(Post.classForCoder())
                .equal(to: self.user.uid, forField: Post.FieldName.userUid)
                .order(byDesc: "timeStamp")
            CloudDBHelper.instance.query(query, Post.self) { posts, error in
                if let error = error {
                    print("DEBUG:: fetchUserPosts: error: \(error.localizedDescription)")
                    return
                }
                guard let posts = posts else {return}
                posts.forEach { post in
                    if !self.userPosts.contains(where: {$0.id == post.id}) {
                        DispatchQueue.main.async { self.userPosts.append(post) }
                    }
                }
            }
        }
    }
    
    func fetchLikedPosts() {
        DispatchQueue.main.async {
            let query = AGCCloudDBQuery.where(LikePost.classForCoder())
                .equal(to: self.user.uid, forField: Post.FieldName.userUid)

            CloudDBHelper.instance.query(query, LikePost.self) { likedPosts, error in
                guard let likedPosts = likedPosts else {return}
                
                let query = AGCCloudDBQuery.where(Post.classForCoder())
                    .inArray(likedPosts.map({$0.postId}), forField: Post.FieldName.id)
                    .order(byDesc: "timeStamp")
                
                CloudDBHelper.instance.query(query, Post.self) { posts, error in
                    posts?.forEach { post in
                        if !self.likedPosts.contains(where: {$0.id == post.id}) {
                            DispatchQueue.main.async { self.likedPosts.append(post) }
                        }
                    }
                }

            }
        }
    }
}
