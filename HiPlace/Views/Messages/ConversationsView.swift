//
//  ConversationsView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 2.06.2021.
//

import SwiftUI

struct ConversationsView: View {
    
    @ObservedObject var viewModel: ConversationsViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.recentConversations, id:\.self) { conservation in
                        NavigationLink(
                            destination: LazyView(ChatView(chattingWith: conservation.user)),
                            label: {
                                ConversationCell(conservation: conservation).id(conservation.message.id)
                            })
                    }
                }
                .padding(.vertical)
            }
            
            
           
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(viewModel: ConversationsViewModel())
    }
}
