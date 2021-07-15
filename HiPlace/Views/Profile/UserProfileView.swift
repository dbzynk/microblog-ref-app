//
//  UserProfileView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import SwiftUI

struct UserProfileView: View {
    @State var selectedFilter: FilterOptions = .posts
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(user: UserInfo) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeaderView(viewModel: viewModel, isFollowed: $viewModel.isFollowed)
                .padding()
                
                FilterButtonView(selectedOption: $selectedFilter)
                    //.frame(width: UIScreen.main.bounds.width)
                    .padding(.vertical)

                if selectedFilter == .posts {
                    ForEach(viewModel.userPosts, id: \.id) { post in
                        PostCell(post: post)
                    }
                } else if selectedFilter == .liked {
                    ForEach(viewModel.likedPosts, id: \.id) { post in
                        PostCell(post: post)
                    }
                }
                
            }
            .navigationTitle(viewModel.user.username)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user:  UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: ""))
    }
}
