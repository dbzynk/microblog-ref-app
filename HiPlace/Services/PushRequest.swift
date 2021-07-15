//
//  PushRequest.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 5.07.2021.
//

import Foundation

class PushRequest {
    static let APP_ID = "322385623856454981"
    static let CLIENT_ID = "104492797"
    static let CLIENT_SECRET = "1ad2b5cecb05c83c902a80e236b9886f4ceb72ca90bdc29e6e25690b9d627ac2"
    static let GET_TOKEN_URL = "https://oauth-login.cloud.huawei.com/oauth2/v3/token"
    static let SEND_PUSH_URL = "https://push-api.cloud.huawei.com/v1/\(APP_ID)/messages:send"
    
    static let shared = PushRequest()
    private init() {}

    func getAccessToken(url: String=PushRequest.GET_TOKEN_URL, completion: @escaping ([String: Any])->Void) {
    
        let body = ["grant_type": "client_credentials",
                    "client_id": PushRequest.CLIENT_ID,
                    "client_secret": PushRequest.CLIENT_SECRET]
        
        HttpRequest.shared.apiReqest(url: url, method: .post, body: body, bodyType: .x_www_form_encoding) { dict, response, error in
            if let error = error {
                // Handle HTTP request error
                print("HttpRequest: getAccessToken: \(error.localizedDescription)")
            }
            if let dict = dict {
                // Handle HTTP request response
                completion(dict)
                
            }
        }

    }
    
    func sendNotification(title: String, body: String, tokens: [String]) {
        
        getAccessToken { [weak self] response in
            guard let accessToken = response["access_token"] as? String else {
                print("cant get access Token from -> \(response)")
                return
            }
            guard let tokenType = response["token_type"] as? String else {
                print("cant get token Type from -> \(response)")
                return
            }
            
            self?.notificationTask(accessToken: accessToken, tokenType: tokenType, title: title, body: body, tokens: tokens)
        }
        
    }
    
    func notificationTask(url: String=PushRequest.SEND_PUSH_URL, accessToken: String, tokenType: String, title: String, body: String, tokens: [String]) {
        
        HttpRequest.shared.apiReqest(url: url, method: .post,
                  headerFields: ["Authorization": "\(tokenType) \(accessToken)"],
                  bodyData: getPushBodyData(title: title, body: body, tokens: tokens)) { dict, _, error in
            if let error = error {
                print("sendNotification:: ERROR: \(error.localizedDescription)")
            }
            if let dict = dict {
                print("sendNotification:: success: \(dict)")
            }
        }
    }

    
    func getPushJsonString(title: String, body: String, tokens: [String]) -> String {
        return """
            {
                "validate_only": false,
                "message": {
                    "apns": {
                       "hms_options": {
                            "target_user_type": 1
                        },
                        "payload": {
                            "aps": {
                                "alert": {
                                    "title": "\(title)",
                                    "body": "\(body)"
                                }
                            }
                            
                        }
                    },
                    "token": \(tokens)
                }
            }
            """
    }
    
    func getPushBodyData(title: String, body: String, tokens: [String]) -> Data? {
        return getPushJsonString(title: title, body: body, tokens: tokens).data(using: .utf8)
    }

    
}
