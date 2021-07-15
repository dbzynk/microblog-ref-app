//
//  ConversationCell.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import SwiftUI

struct ConversationCell: View {
    
    let conservation: Conversation

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                ProfileImageView(imageUrl: conservation.user.profileImageUrl, width: 56, height: 56)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(conservation.user.username )
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(conservation.message.message.text )
                        .font(.system(size: 14))
                        .lineLimit(2)
                        .frame(height: 35)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundColor(Color(.label))
            }
            .padding(.horizontal)
            Divider()
        }
        
    }
}

//struct ConversationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationCell(message: "1")
//    }
//}
