//
//  ProfileHeaderView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {

    let viewModel: ProfileViewModel
    @Binding var isFollowed: Bool

    var body: some View {
        VStack {
            ProfileImageView(imageUrl: viewModel.user.profileImageUrl, width: 120, height: 120)
                .shadow(color: Color(.label), radius: 6)
            
            Text(viewModel.user.fullName)
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 8)
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            
            
            HStack(spacing: 40) {
                VStack {
                    Text(viewModel.userStats.followersCount)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Followers")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text(viewModel.userStats.followingCount)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Following")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            ProfileActionButtonView(viewModel: viewModel, isFollowed: $isFollowed)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ProfileViewModel(user:  UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: ""))
        ProfileHeaderView(viewModel: vm, isFollowed: .constant(false))
    }
}
