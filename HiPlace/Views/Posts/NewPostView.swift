//
//  NewPostView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import SwiftUI
import Kingfisher

struct NewPostView: View {
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel = UploadPostViewModel()
    @StateObject var alert = HiPlaceAlert()
    
    var onSentSuccessfully: (()->Void)?=nil
    
    var body: some View {
        ZStack {
            LoadingIndicatorView(showIndicator: $alert.showLoadingIndicator)
            BannerView(title: alert.title, detail: alert.detail, type: alert.bannerType, showBanner: $alert.showBannerMessge)
            
            VStack {
            HStack{
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Text("Cancel").bold()
                        .foregroundColor(Color(.systemGreen))
                })
                
                Spacer()
                
                Button(action: {
                    if captionText.isEmpty {
                        alert.showBanner(title: "Warning", detail: "Post cannot be empty!", type: .warning)
                        return
                    }
                    else if captionText.count > 200 {
                        alert.showBanner(title: "Warning", detail: "Post cannot be more than 200 character! Current character count: \(captionText.count)", type: .warning)
                        return
                    }
                    alert.showLoadingIndicator = true

                    viewModel.uploadPost(text: captionText) { error in
                        if let error = error {
                            alert.showLoadingIndicator(false)
                            alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error)
                            return
                        }
                        alert.showBanner(title: "Success", detail: "your post uploaded successfully", type: .success)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            alert.showLoadingIndicator(false)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isPresented.toggle()
                            onSentSuccessfully?()
                        }
                    }
                }, label: {
                    Text("Post")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemGreen))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
            }
            .padding(.horizontal)
            
            HStack(alignment: .top) {
                ProfileImageView(imageUrl: AuthService.shared.user?.profileImageUrl, width: 64, height: 64)

                TextAreaView(placeholder: "What's happenning?", text: $captionText)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            Spacer()
        }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(isPresented: .constant(true))
    }
}
