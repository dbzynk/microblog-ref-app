//
//  ChatViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 22.06.2021.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    let user: UserInfo
    @Published var messages = [Message]()
    @Published var isLoading = true
    var scrollViewProxy: ScrollViewProxy?

    private var receivedMessagesListenerHandler: AGCCloudDBListenerHandler?
    private var sentMessagesListenerHandler: AGCCloudDBListenerHandler?
    
    init(chattingWith: UserInfo) {
        self.user = chattingWith
        // listen messages that user is received to update messages array
        listenReceivedMessages()
        // listen messages that user is sent to update messages array
        listenSentMessages()
        observeKeyboard()
    }
    
    private func setIsloading(_ bool: Bool) {
        DispatchQueue.main.async {
            self.isLoading = bool
        }
    }
    
    private func listenReceivedMessages() {
        guard let currentUserUid = AuthService.shared.userSession?.uid else {return}
        
        let query = AGCCloudDBQuery.where(Message.classForCoder())
            .equal(to: self.user.uid, forField: Message.FieldName.fromUserUid)
            .equal(to: currentUserUid, forField: Message.FieldName.toUserUid)
        
        CloudDBHelper.instance.listenData(query: query, typeOf: Message.self, listenerHandler: &receivedMessagesListenerHandler, completion: appendMessages)
    }
    
    private func listenSentMessages() {
        guard let currentUserUid = AuthService.shared.userSession?.uid else {return}
        
        let query = AGCCloudDBQuery.where(Message.classForCoder())
            .equal(to: self.user.uid, forField: Message.FieldName.toUserUid)
            .equal(to: currentUserUid, forField: Message.FieldName.fromUserUid)
        
        CloudDBHelper.instance.listenData(query: query, typeOf: Message.self, listenerHandler: &sentMessagesListenerHandler, completion: appendMessages)
    }
    
    private func appendMessages(messages: [Message]?, error: Error?) {
        setIsloading(false)
        guard let messages = messages else {return}
        messages.forEach { message in
            if self.messages.contains(where: {$0.id == message.id}) {return}
            DispatchQueue.main.async {
                self.messages.append(message)
                self.messages.sort(by: { $0.timestamp < $1.timestamp } )
            }
        }
    }
    
    func sendMessage(_ messageText: String, completion: @escaping (Error?) -> Void) {
        if messageText.isEmpty {return}
        guard let currentUser = AuthService.shared.user else {return}
        let message = Message(fromUserUid: currentUser.uid, toUserUid: user.uid, message: messageText, id: UUID().uuidString, timestamp: Date())
        CloudDBHelper.instance.upsertOne(data: message) { error in
            if let error = error {
                completion(error)
                return
            }
            CloudDBHelper.instance.upsertOne(data: message.toRecentMessage()) {error in
                if error == nil {
                    PushRequest.shared.sendNotification(title: currentUser.fullName, body: messageText, tokens: [self.user.pushToken])
                }
                completion(error)
            }
        }
    }
    
    func stopListening() {
        if let receivedMessagesListenerHandler = receivedMessagesListenerHandler {
            receivedMessagesListenerHandler.remove()
        }
        if let sentMessagesListenerHandler = sentMessagesListenerHandler {
            sentMessagesListenerHandler.remove()
        }
        removeKeyboardObserver()
    }
    
    deinit {
        stopListening()
    }
}

//
// MARK: Scroll to bottom when keyboard show up
//
extension ChatViewModel {
    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.scrollViewProxy?.scrollTo(self.messages.last?.id)
        }
    }
}
