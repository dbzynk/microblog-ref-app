//
//  FeedViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 17.06.2021.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading = true
    @Published var alert = HiPlaceAlert()

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchPosts()
        }
    }
    
    func fetchPosts(onComplete: (() -> Void)? = nil) {
        DispatchQueue.main.async { self.isLoading = true }
        let query = AGCCloudDBQuery.where(Post.classForCoder()).order(byDesc: "timeStamp")
        CloudDBHelper.instance.query(query, Post.self) { posts, error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                print("DEBUG:: fetchPosts: error: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error) }
                onComplete?()
                return
            }
            if let posts = posts, self.posts.first?.id != posts.first?.id {
                DispatchQueue.main.async {
                    self.posts = posts
                    onComplete?()
                }
            }
        }
    }
}
