//
//  VerifyView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct VerifyView: View {
    @Binding var userData: RegistrationModel
    @State private var verifyCode: String = ""
    @State private var timeRemaining = 30
    @ObservedObject var alert : HiPlaceAlert
    var verifyMessage = "Please enter the verification code that is sent to your e-mail"
    var onComplete: (String) -> Void
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var viewModel = AuthViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    private let maxWidth: CGFloat = 450

    var body: some View {
        ZStack(alignment: .top) {
            Color(.primary)
                .edgesIgnoringSafeArea(.all)
            
            BannerView(title: alert.title, detail: alert.detail, type: alert.bannerType, showBanner: $alert.showBannerMessge).frame(maxWidth: maxWidth)
            ToastView(title: alert.title, image: alert.image, showToast: $alert.showToastMessage)
            LoadingIndicatorView(showIndicator: $alert.showLoadingIndicator)

            
            VStack {
                HStack {
                    Button(action: {
                        mode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }).padding()

                    Spacer()
                }
                
                VStack(spacing:30) {

                    CountDownProgressBar(seconds: 30, timer: $timeRemaining, width: 100, height: 100, lineWidth: 10)
                        .foregroundColor(.white)
                
                    Text("\(verifyMessage)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        
                    
                    CustomTextField(text: $verifyCode, placeholder: "Verification Code", textContentType: .creditCardNumber)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        print("code is :: \(verifyCode)")
                        alert.showLoadingIndicator = true
                        onComplete(verifyCode)

                    }, label: {
                        Text("Verify")
                            .bold()
                            .padding()
                            .padding(.horizontal, 40)
                            .background(Color.white)
                            .foregroundColor(Color(.accent))
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    })
                    
                }
                .padding().padding()
                .frame(maxWidth: maxWidth)
            }
            .navigationBarHidden(true)
            
            
        }
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }else {
                self.timer.upstream.connect().cancel()
            }
        }
        .onDisappear() {
            alert.showLoadingIndicator = false
        }
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView(userData: .constant(RegistrationModel()), alert: HiPlaceAlert(), onComplete: {_ in })
    }
}
