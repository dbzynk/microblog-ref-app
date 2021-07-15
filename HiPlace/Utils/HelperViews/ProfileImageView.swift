//
//  ProfileImageView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 21.06.2021.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    
    @State var imageUrl: String?
    var width: CGFloat=35
    var height: CGFloat=35
    
    var showAuthenticatedUser = false
    
    
    var body: some View {
        if let profileImageUrl = imageUrl,
           !profileImageUrl.isEmpty,
           let url = URL(string: profileImageUrl) {
            KFImage(url)
                .resizable()
                .clipShape(Circle())
                .scaledToFill()
                .frame(width: width, height: height)
        }
        else if showAuthenticatedUser {
            if let url = AuthService.shared.user?.profileImageUrl, !url.isEmpty {
                KFImage(URL(string: url))
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: width, height: height)
            } else {
                DefaultImage()
                    .onReceive(AuthService.shared.$user) { user in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.imageUrl = AuthService.shared.user?.profileImageUrl
                    }
                }
            }
            
        }
        else {
            DefaultImage()
        }
    }
    
    func DefaultImage() -> some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .foregroundColor(.gray)
            .background(Color.white)
            .clipShape(Circle())
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(imageUrl: ("https://firebasestorage.googleapis.com:443/v0/b/twitter---clone-368a0.appspot.com/o/479967A8-A635-4C3B-A54C-4DD8955CE68D?alt=media&token=1228542a-d6b6-47d8-8994-5b0c9155eb0b"), width: 120, height: 120)
    }
}
