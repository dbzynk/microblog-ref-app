//
//  RegistrationView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct RegistrationView: View {

    @State private var userData = RegistrationModel()
    
    @State private var isShowVerifyView = false
    @State var isShowImagePicker = false
    @State var selectedUIImage: UIImage?

    @StateObject private var alert = HiPlaceAlert()
    var viewModel = AuthViewModel()
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
                Button(action: {
                    //isShowImagePicker.toggle()
                    alert.showBanner(title: "Upss..", detail: "Cloud Storage is not released for iOS yet :/", type: .warning)
                }, label: {
                    if selectedUIImage != nil {
                        Image(uiImage: selectedUIImage!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .padding(.vertical)
                    } else {
                    Image("plus_photo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                        .padding(.vertical)
                    }
                })
                .sheet(isPresented: $isShowImagePicker, content: {
                    ImagePickerView(image: $selectedUIImage)
                })
               
                
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        CustomTextField(text: $userData.email, placeholder: "Email", imageName: "envelope", textContentType: .emailAddress, textAutoCapitalizationType: .none)
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                        
                        CustomTextField(text: $userData.fullName, placeholder: "Full Name", imageName: "person", textContentType: .name)
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                        
                        CustomTextField(text: $userData.username, placeholder: "Username", imageName: "person.fill", textContentType: .username, textAutoCapitalizationType: .none)
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                    
                        CustomTextField(text: $userData.password, placeholder: "Password", imageName: "lock", isSecure: true)
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                        
                    }
                    .padding(.bottom, 20)

                    Button(action: {
                        if !checkFields() {return}
                        alert.showLoadingIndicator = true
                        viewModel.verifyUser(email: userData.email, config: .registerLogin) { result, error in

                            if result == true {
                                isShowVerifyView = true
                            }
                            if let error = error {
                                alert.showLoadingIndicator = false
                                if error._code == AuthService.ErrorCode.verifyCodeAlreadySent.rawValue {
                                    isShowVerifyView = true
                                    self.alert.showBanner(title: "Error", detail: error.localizedDescription, type: .info)
                                } else {
                                    self.alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error)
                                }
                            }
                            
                        }
                    }, label: {
                        Text("Sign Up").bold()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .foregroundColor(Color(.accent))
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    })
                    
                    NavigationLink(
                        destination: // VerifyView(userData: $userData, alert: alert)
                        
                        VerifyView(userData: $userData, alert: alert) { verifyCode in
                            viewModel.handleRegisterUser(userData: userData, verifyCode: verifyCode, alert: alert)
                        },
                        isActive: $isShowVerifyView,
                        label: {})
                    
                    Spacer()
                    
                    HStack {
                        Text("Already have an account?")
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
        userData.username = userData.username.trimmingCharacters(in: .whitespacesAndNewlines)
        userData.fullName = userData.fullName.trimmingCharacters(in: .whitespacesAndNewlines)

        if userData.email.isEmpty {
            alert.showBanner(title: "Warning", detail: "E-mail is wrong", type: .warning)
            return false
        }
        if userData.username.isEmpty {
            alert.showBanner(title: "Warning", detail: "Username is wrong", type: .warning)
            return false
        }
        if userData.password.count < 6 {
            alert.showBanner(title: "Warning", detail: "Password is wrong", type: .warning)
            return false
        }
        if userData.fullName.isEmpty {
            alert.showBanner(title: "Warning", detail: "Name is wrong", type: .warning)
            return false
        }
        return true
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()//.environmentObject(AuthViewModel.shared)
    }
}
