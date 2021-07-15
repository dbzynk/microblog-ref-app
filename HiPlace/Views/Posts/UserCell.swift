//
//  UserCell.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 1.06.2021.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
    var user: UserInfo

    var body: some View {
        HStack(spacing: 12) {
            ProfileImageView(imageUrl: user.profileImageUrl, width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.system(size: 14, weight: .semibold))
                
                Text("@\(user.username)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .foregroundColor(Color(.label))
            
        }
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {        
        UserCell(user: UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: ""))
    }
}
