//
//  LoginView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var showDismiss = false
    
    var viewModel = AuthViewModel()
    @StateObject private var alert = HiPlaceAlert()
    
    private let maxWidth: CGFloat = 500
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.primary)
                    .edgesIgnoringSafeArea(.all)
                
                BannerView(title: alert.title, detail: alert.detail, type: alert.bannerType, showBanner: $alert.showBannerMessge).frame(maxWidth: maxWidth)
                ToastView(title: alert.title, image: alert.image, showToast: $alert.showToastMessage)
                LoadingIndicatorView(showIndicator: $alert.showLoadingIndicator)

                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 20) {
                            CustomTextField(text: $email, placeholder: "Email", imageName: "envelope", textContentType: .emailAddress, textAutoCapitalizationType: .none)
                                .padding()
                                .background(Color(.init(white: 1, alpha: 0.15)))
                                .cornerRadius(10)
                            
                            CustomTextField(text: $password, placeholder: "Password", imageName: "lock", isSecure: true)
                                .padding()
                                .background(Color(.init(white: 1, alpha: 0.15)))
                                .cornerRadius(10)
                            
                        }
                        
                        HStack{
                            Spacer()
//                            Button(action: {
//                                endEditing()
//                                alert.showBanner(title: "Sorry !", detail: "This feature is not implemented yet :/", type: .info)
//                            }, label: {
//                                Text("Forgot Password?")
//                                    .font(.system(size: 16, weight: .semibold))
//                            })
                            
                            NavigationLink(destination: ForgotPasswordView(), label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 16, weight: .semibold))
                            })

                        }
                        
                        Button(action: {
                            endEditing()
                            alert.showLoadingIndicator = true
                            viewModel.login(withEmail: email, password: password) { result, error in
                                if result == true {
                                    alert.showBanner(title: "Success!", detail: "Successfully logged in!", type: .success)
                                }
                                if let error = error {
                                    alert.showLoadingIndicator = false
                                    alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error)
                                }
                            }
                        }, label: {
                            Text("Sign In").bold()
                                .frame(width: 300, height: 50)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .foregroundColor(Color(.accent))
                                .shadow(radius: 5)
                        })
                        
                        Spacer()
                        
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 15))
                            
                            NavigationLink(destination: RegistrationView(), label: {
                                Text("Sign Up")
                                    .font(.system(size: 15, weight: .semibold))
                            })
                            
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding()
                    
                }
                .frame(maxWidth: maxWidth)
                                
            }
            .onDisappear() {
                //alert.showLoadingIndicator = false
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
