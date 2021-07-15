//
//  ForgotPasswordView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 12.07.2021.
//

import SwiftUI

struct ForgotPasswordView: View {
   
    @State private var userData = RegistrationModel()
    
    @State private var isShowVerifyView = false
    private let viewModel = AuthViewModel()
    
    @StateObject private var alert = HiPlaceAlert()

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    private let maxWidth: CGFloat = 500

    var body: some View {
        ZStack(alignment: .top) {
            Color(.primary)
                .edgesIgnoringSafeArea(.all)
            
            BannerView(title: alert.title, detail: alert.detail, type: alert.bannerType, showBanner: $alert.showBannerMessge).frame(maxWidth: maxWidth)
            ToastView(title: alert.title, image: alert.image, showToast: $alert.showToastMessage)
            LoadingIndicatorView(showIndicator: $alert.showLoadingIndicator)
            
          
            VStack {
                VStack(spacing: 20) {
                    
                    VStack  {
                        Text("Forgot Your Password?")
                            .font(.largeTitle).bold()
                    }
                    .padding(.vertical)

                    VStack(spacing: 20) {
                        CustomTextField(text: $userData.email, placeholder: "Email", imageName: "envelope", textContentType: .emailAddress, textAutoCapitalizationType: .none)
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                        
                        CustomTextField(text: $userData.password, placeholder: "New Password", imageName: "lock", isSecure: true)
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                        
                    }

                    Button(action: {
                         if !checkFields() {return}
                        alert.showLoadingIndicator = true
                        viewModel.verifyUser(email: userData.email, config: .resetPassword, callback: { result, error in
                            alert.showLoadingIndicator = false
                            if result == true {
                                isShowVerifyView = true
                            }
                            if let error = error {
                                self.alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error)
                            }
                        })
                    }, label: {
                        Text("Reset Password").bold()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .foregroundColor(Color(.accent))
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    })
                    
                    NavigationLink(
                        destination: VerifyView(userData: $userData, alert: alert) { verifyCode in
                            viewModel.handleForgotPassword(userData: userData, verifyCode: verifyCode, alert: alert)
                        },
                        isActive: $isShowVerifyView,
                        label: {})
                    
                    Spacer()
                    
                    HStack {
                        Text("Remembered your credentials?")
                            .font(.system(size: 15))
                        
                        Button(action: {
                            mode.wrappedValue.dismiss()
                        }, label: {
                            Text("Sign In")
                                .font(.system(size: 15, weight: .semibold))
                        })
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding()
                .frame(maxWidth: maxWidth)
                
                
            }
            .onDisappear() {
                alert.showLoadingIndicator = false
            }
            .navigationBarHidden(true)
        }
    }
    
    func checkFields() -> Bool {
        endEditing()
        userData.email = userData.email.trimmingCharacters(in: .whitespacesAndNewlines)

        if userData.email.isEmpty {
            alert.showBanner(title: "Warning", detail: "E-mail is wrong", type: .warning)
            return false
        }
        if userData.password.count < 6 {
            alert.showBanner(title: "Warning", detail: "Password is wrong", type: .warning)
            return false
        }
        return true
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
