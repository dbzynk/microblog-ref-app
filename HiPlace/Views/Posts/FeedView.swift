//
//  FeedView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 28.06.2021.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
    @State private var isShowingNewPostView: Bool = false
    @State var redactionReason = RedactionReasons.init()

    var body: some View {
        ZStack{
            ZStack(alignment: .bottomTrailing) {
                
                RefreshScrollView(content:
                        VStack {
                            ForEach(viewModel.posts, id: \.id) { post in
                                PostCell(post: post)
                            }
                        },
                        onUpdate: { onComplete in
                            self.redactionReason = .placeholder
                            viewModel.fetchPosts() {
                                self.redactionReason = RedactionReasons.init()
                                onComplete()
                            }
                        }
                )
                
                NewPostFloatingActionButton()
            }
            
            BannerView(title: viewModel.alert.title, detail: viewModel.alert.detail, type: viewModel.alert.bannerType, showBanner: $viewModel.alert.showBannerMessge)
        }
    }
    
    func NewPostFloatingActionButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                isShowingNewPostView.toggle()
            }, label: {
                Image("tweet")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding()
                
            })
            .background(Color(.systemGreen))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $isShowingNewPostView) {
                NewPostView(isPresented: $isShowingNewPostView, onSentSuccessfully: { viewModel.fetchPosts() })
            }
        }
    }

}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
