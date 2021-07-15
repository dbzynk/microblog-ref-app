//
//  MessagesTabView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 25.06.2021.
//

import SwiftUI

struct MessagesTabView: View {
    @ObservedObject private var viewModel = ConversationsViewModel()
    @State var user: UserInfo?
    @State var isShowNewMessageView = false
    @State var isShowChat = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if let user = user {
                    NavigationLink(
                        destination: LazyView(ChatView(chattingWith: user)),
                        isActive: $isShowChat,
                        label: {})
                }
                
                ScrollView {
                    VStack {
                        ForEach(viewModel.recentConversations, id:\.message.id) { conservation in
                            NavigationLink(
                                destination: LazyView(ChatView(chattingWith: conservation.user)),
                                label: {
                                    ConversationCell(conservation: conservation)
                                })
                        }
                    }
                    .padding(.vertical)
                }
                .onAppear() {
                    viewModel.startListening()
                }
                .onDisappear() {
                    viewModel.stopListening()
                }
                .blur(radius: viewModel.isLoading ? 2 : 0)

                NewMessageFloatingActionButton()
                
                if viewModel.isLoading {
                    SmallLoadingIndicatorView()
                }
            }
            .navigationBarTitle("Messages", displayMode: .inline)
        }
    }
    
    func NewMessageFloatingActionButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                self.isShowNewMessageView.toggle()
            }, label: {
                Image(systemName: "envelope")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding()
                
            })
            .background(Color(.systemGreen))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .sheet(isPresented: $isShowNewMessageView, content: {
                NewMessageView(show: $isShowNewMessageView, isStartChat: $isShowChat, user: $user)
            })
        }

    }
}


struct MessagesTabView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesTabView()
    }
}
