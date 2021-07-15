//
//  ChatBubleView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import SwiftUI

struct ChatBubleView: View {
    let message: Message
    let user: UserInfo
    
    init(message: Message, chattingWith: UserInfo) {
        self.message = message
        self.user = chattingWith
    }
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser() {
                Spacer()
                Text(message.message.text)
                    .padding()
                    .background(Color(.accent))
                    .clipShape(ChatBubbleShape(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.leading, 100)
                    .padding(.trailing, 16)
                
            } else {
                
                HStack(alignment: .bottom) {
                    ProfileImageView(imageUrl: user.profileImageUrl, width: 40, height: 40)
                    
                    Text(message.message.text)
                        .padding()
                        .background(Color(.systemGray5))
                        .clipShape(ChatBubbleShape(isFromCurrentUser: false))
                        .foregroundColor(Color(.label))
                        .font(.system(size: 16))
                        
                }
                .padding(.leading, 16)
                .padding(.trailing, 100)
                Spacer()
            }
        }
        
    }
}

struct ChatBubleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubleView(message: Message(), chattingWith: UserInfo())
    }
}
