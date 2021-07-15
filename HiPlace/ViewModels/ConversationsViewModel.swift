//
//  ConversationsViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 22.06.2021.
//

import Foundation

struct Conversation: Hashable {
    var message: Message
    let user: UserInfo
}

class ConversationsViewModel: ObservableObject {
    
    @Published var recentConversations = [Conversation]()
    var recentRetrievedConversationsDict = [String: Conversation]()
    @Published var isLoading = true

    private var isListening = false
    private var recentRetrievedMessagesListenerHandler: AGCCloudDBListenerHandler?
    private var recentSentMessagesListenerHandler: AGCCloudDBListenerHandler?
    
    init() {
        startListening()
    }
    
    func startListening() {
        if !isListening {
            isListening.toggle()
            listenRecentRetrievedMessages()
            listenRecentSentMessages()
        }
    }
    
    func stopListening() {
        isListening = false
        recentRetrievedMessagesListenerHandler?.remove()
        recentSentMessagesListenerHandler?.remove()
        recentRetrievedMessagesListenerHandler = nil
        recentSentMessagesListenerHandler = nil
    }
    
    private func listenRecentSentMessages() {
        // listen messages that user is sent to update messages array
        
        guard let currentUserUid = AuthService.shared.userSession?.uid else {return}
        
        let query = AGCCloudDBQuery.where(RecentMessage.classForCoder())
            .equal(to: currentUserUid, forField: RecentMessage.FieldName.fromUserUid)
        
        CloudDBHelper.instance.listenData(query: query, typeOf: RecentMessage.self, listenerHandler: &recentSentMessagesListenerHandler, completion: RecentlySentConversationIsReceived)
    }
    
    private func listenRecentRetrievedMessages() {
        // listen messages that user is received to update messages array

        guard let currentUserUid = AuthService.shared.userSession?.uid else {return}
        
        let query = AGCCloudDBQuery.where(RecentMessage.classForCoder())
            .equal(to: currentUserUid, forField: RecentMessage.FieldName.toUserUid)
        
        CloudDBHelper.instance.listenData(query: query, typeOf: RecentMessage.self, listenerHandler: &recentRetrievedMessagesListenerHandler, completion: RecentlyReceivedConversationIsReceived)
    }
    
    private func RecentlySentConversationIsReceived(recentMessages: [RecentMessage]?, error: Error?) {
        setIsloading(false)
        guard let currentUid = AuthService.shared.userSession?.uid else {return}
        // guard let recentMessage = recentMessages?.first else {return}
        recentMessages?.forEach { recentMessage in
            guard recentMessage.fromUserUid == currentUid else {return}

            let newMessage = Message(fromUserUid: recentMessage.toUserUid, toUserUid: recentMessage.fromUserUid,
                                     message: recentMessage.message.text, id: recentMessage.messageId,
                                     timestamp: recentMessage.timestamp)
            appendConversation(by: newMessage)
        }
    }
    
    private func RecentlyReceivedConversationIsReceived(recentMessages: [RecentMessage]?, error: Error?) {
       setIsloading(false)
        recentMessages?.forEach { newMessage in
            appendConversation(by: newMessage.toMessage())
        }
    }
    
    private func setIsloading(_ bool: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = bool
        }
    }
}

//
// MARK: APPEND LISTENED CONVERSATION
//
extension ConversationsViewModel {
    private func appendConversation(by newMessage: Message) {
        if !findAndUpdateMessage(newMessage) {
            let query = AGCCloudDBQuery.where(UserInfo.classForCoder()).equal(to: newMessage.fromUserUid, forField: UserInfo.FieldName.uid)
            
            CloudDBHelper.instance.query(query, UserInfo.self) { data,error in
                guard let user = data?.first else {return}
                let newConversation = Conversation(message: newMessage, user: user)

                if !self.findAndUpdateConversation(newConversation) {
                    self.appendAndSortConversation(newConversation)
                }
            }
        }
    }
    
    private func findAndUpdateMessage(_ newMessage: Message) -> Bool {
        if let index = self.recentConversations.firstIndex(where: { $0.user.uid == newMessage.fromUserUid }) {
            if newMessage.timestamp > self.recentConversations[index].message.timestamp {
                updateMessageAndSort(index: index, newMessage: newMessage)
            }
            return true
        }
        return false
    }
    
    private func findAndUpdateConversation(_ newConversation: Conversation) -> Bool {
        if let index = self.recentConversations.firstIndex(where: { $0.user.uid == newConversation.message.fromUserUid }) {
            if newConversation.message.timestamp > self.recentConversations[index].message.timestamp {
                updateMessageAndSort(index: index, newMessage: newConversation.message)
            }
            return true
        }
        return false
    }
    
    private func updateMessageAndSort(index: Int, newMessage: Message) {
        DispatchQueue.main.async {
            self.recentConversations[index].message = newMessage
            self.recentConversations.sort(by: {$0.message.timestamp > $1.message.timestamp })
        }
    }
    
    private func appendAndSortConversation(_ newConversation: Conversation) {
        DispatchQueue.main.async {
            self.recentConversations.append(newConversation)
            self.recentConversations.sort(by: {$0.message.timestamp > $1.message.timestamp })
        }
    }
}
