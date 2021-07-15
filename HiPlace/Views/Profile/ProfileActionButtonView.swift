//
//  ProfileActionButtonView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct ProfileActionButtonView: View {
    
    let viewModel: ProfileViewModel
    @Binding var isFollowed: Bool
    
    var body: some View {
        VStack {
            if viewModel.user.isCurrentUser {
                Button(action: {}, label: {
                    Text("Edit Profile")
                        .frame(width: 360, height: 40)
                        .background(Color(.systemGreen))
                        .foregroundColor(.white)
                })
                .cornerRadius(20)
                .shadow(radius: 6)
            }
            else {
                HStack {
                    Button(action: {
                        isFollowed ? viewModel.unfollow() : viewModel.follow()
                    }, label: {
                        Text(isFollowed ? "Following" : "Follow")
                            .frame(width: 180, height: 40)
                            .background(Color(.systemGreen))
                            .foregroundColor(.white)
                    })
                    .cornerRadius(20)
                    .shadow(radius: 6)
                    
                    NavigationLink(
                        destination: LazyView(ChatView(chattingWith: viewModel.user)),
                        label: {
                            Text("Message")
                                .frame(width: 180, height: 40)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(radius: 6)
                        })
                }
            }
        }
    }
}

struct ProfileActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionButtonView(viewModel: ProfileViewModel(user:  UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: "")), isFollowed: .constant(false))
    }
}
