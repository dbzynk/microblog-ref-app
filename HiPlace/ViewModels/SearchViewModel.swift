//
//  SearchViewModel.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 14.06.2021.
//

import Foundation

class SearchViewModel: ObservableObject {
    enum Configuration {
        case newMessage
        case search
    }
    
    @Published var users = [UserInfo]()
    let config: Configuration
    
    init(config: Configuration) {
        self.config = config
        self.fetchUsers()
    }
    
    func fetchUsers(by searchText: String, limit: Int32 = 25) {
        guard let currentUser = AuthService.shared.user else { return }
        let query = AGCCloudDBQuery.where(UserInfo.classForCoder())
        
        if !searchText.isEmpty {
            query.contains(searchText, forField: UserInfo.FieldName.username)
        }
        
        switch self.config {
        case .search:
            query.limit(limit)
            
        case .newMessage:
            // show users except user self
            query.notEqual(to: currentUser.uid, forField: UserInfo.FieldName.uid)
                .limit(limit)
        }
        
        CloudDBHelper.instance.query(query, UserInfo.self) { fetchedUsers, error in
            if let error = error {
                print("DEBUG:: fetchUsers Error: \(error.localizedDescription)")
                return
            }
            guard let fetchedUsers = fetchedUsers else {return}
            DispatchQueue.main.async {
                self.users = fetchedUsers
            }
        }
    }
    
    func fetchUsers() {
        fetchUsers(by: "")
    }
}
