//
//  PostActionsView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 21.06.2021.
//

import SwiftUI

struct PostActionsView: View {
    let post: Post
    @ObservedObject var viewModel: PostActionsViewModel
    
    init(post: Post, viewModel: PostActionsViewModel) {
        self.post = post
        self.viewModel = viewModel//PostActionsViewModel(post: self.post)
    }
    
    var body: some View {
        ZStack {
            HStack {
            //Spacer()
            //Button(action: { }, label: {
             //   Image(systemName: "bubble.left")
            //})
            //.frame(width: 32, height: 32)
            
            //Spacer()
            //Button(action: {}, label: {
            //    Image(systemName: "arrow.2.squarepath")
            //})
            //    .frame(width: 32, height: 32)
            
            Spacer()
            Button(action: {
                if !viewModel.didLike {
                    viewModel.likePost()
                } else {
                    viewModel.unlikePost()
                }
            }, label: {
                HStack(spacing: 0) {
                    Image(systemName: viewModel.didLike ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.didLike ? .red : .gray)
                        .frame(width: 32, height: 32)
                    
                    Text("\(post.likeCount)").font(.subheadline)
                    .foregroundColor(viewModel.didLike ? .red : .gray)
                }.offset(x: -15)
            })
            
           // Spacer()
           // Button(action: {}, label: {
            //    Image(systemName: "bookmark")
            //})
           // .frame(width: 32, height: 32)
            Spacer()
        }
        .foregroundColor(.gray)
        .font(.system(size: 16))
        .padding(.horizontal)
    }
    }
}
