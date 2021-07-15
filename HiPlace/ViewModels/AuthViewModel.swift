//
//  AuthViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

class AuthViewModel {
    
    func login(withEmail email: String, password: String, callback: ((_ success: Bool?, _ error: Error?)->Void)?=nil) {
        AuthService.shared.login(withEmail: email, password: password) { result in
            guard let user = result?.user else {return}
            print("DEBUG:: Successfully logged in!")
            AnalyticsService.shared.setUserProfile("userLoginUid", setValue: user.uid)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                AuthService.shared.userSession = user
                AuthService.shared.fetchUser()
            }
            callback?(true, nil)
        } onFailure: { error in
            print("DEBUG:: ERROR login: \(error?.localizedDescription ?? "error")")
            callback?(nil, error)
        }
    }
    
    func verifyUser(email:String, config: AuthService.SettingConfig, callback: ((_ success: Bool?, _ error: Error?)->Void)?=nil) {
        print("DEBUG:: Email is \(email)")
        AuthService.shared.verifyUser(email: email, config: config) { (result) in
            
            guard let result = result else {print("DEBUG:: Verify : result is nil"); return}
            print("DEBUG:: Verify : \(result)")
            callback?(true, nil)
        }
        onFailure: {(error) in
            print("DEBUG:: Verify Error: \(error)")
            callback?(nil, error)
        }
        
    }
    
    func createUser(userData: RegistrationModel, verifyCode: String, callback: ((_ success: Bool?, _ error: Error?)->Void)?=nil) {
        AuthService.shared.createUser(userData: userData, verifyCode: verifyCode) { result in
            guard let user = result?.user else { print("DEBUG:: createUser: result is nil"); return }
            print("DEBUG:: createUser: \(user.debugDescription)")
            let userInfo = userData.toUserInfo()
            userInfo.uid = user.uid
            if let huaweiToken = huaweiToken {
                userInfo.pushToken = huaweiToken
            }
            AnalyticsService.shared.onEvent("registerUser", setParams: ["userUid": userInfo.uid, "email": userInfo.email])

            CloudDBHelper.instance.upsertOne(data: userInfo) { error in
                if let error = error {
                    print("DEBUG:: executeUpsertOne: error: \(error.localizedDescription)")
                    callback?(nil, error)
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    AuthService.shared.userSession = user
                    AuthService.shared.fetchUser()
                }
                callback?(true, nil)
            }
        } onFailure: { error in
            print("DEBUG:: createUser ERROR: \(error?.localizedDescription ?? "error")")
            callback?(nil, error)
        }
    }
    

    func resetPassword(email: String, password: String, verifyCode: String, onSuccess: ((AnyObject?)->Void)?=nil, onFailure: ((Error)->Void)?=nil) {
       AuthService.shared.resetPassword(email: email, password: password, verifyCode: verifyCode, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    
    func signOut() {
        AuthService.shared.signOut()
    }
}

//
// MARK: IBActions
//
extension AuthViewModel {
    func handleForgotPassword(userData: RegistrationModel, verifyCode: String, alert: HiPlaceAlert) {
        self.resetPassword(email: userData.email, password: userData.password, verifyCode: verifyCode) { _ in
            alert.showBanner(title: "Success !", detail: "Password is reset succesfully. Please wait while logging in...", type: .success)
            // login
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.login(withEmail: userData.email, password: userData.password) { result, error in

                    if result != true ||  error != nil {
                        alert.showLoadingIndicator = false
                        alert.showBanner(title: "Error", detail: error?.localizedDescription, type: .error)
                    }
                }
            }
        } onFailure: { error in
            alert.showLoadingIndicator = false
            alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error)
        }
    }
    
    func handleRegisterUser(userData: RegistrationModel, verifyCode: String, alert: HiPlaceAlert) {
        self.createUser(userData: userData, verifyCode: verifyCode) { result, error in
            
            if result == true {
                alert.showBanner(title: "Success!", detail: "You are registered", type: .success)
            }
            if let error = error {
                alert.showLoadingIndicator = false
                alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error)
            }
        }
    }
}
