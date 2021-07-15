//
//  MessageInputView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var messageText: String
    var placeHolderText = "Message..."
    let action: () -> Void
    
    var body: some View {
        HStack {
            DynamicTextAreaView(text: $messageText, placeholder: placeHolderText, lineLimit: 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
         
            Button(action: action, label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(.systemGreen))
                    .background((Color.white))
                    .clipShape(Circle())
                    .rotationEffect(.init(degrees: 45))
            })
        }
        
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(messageText: .constant("Hello"), action: {})
            .preferredColorScheme(.dark)
    }
}
