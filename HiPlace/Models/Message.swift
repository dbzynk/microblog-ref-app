//
//  Message.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import Foundation

struct MockMessage: Identifiable {
    let id:Int
    let imageName: String
    let messageText: String
    let isCurrentUser: Bool
}
