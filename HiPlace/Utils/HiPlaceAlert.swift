//
//  HiPlaceAlert.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 8.06.2021.
//

import Foundation

class HiPlaceAlert: ObservableObject {
    
    static let shared = HiPlaceAlert()

    @Published var title = "Title"
    @Published var detail = "your message"
    @Published var image = ""
    @Published var bannerType : BannerType = .warning
    @Published var showBannerMessge = false
    @Published var showToastMessage = false
    @Published var showLoadingIndicator = false

    func showLoadingIndicator(_ bool: Bool) {
        DispatchQueue.main.async {
            self.showLoadingIndicator = bool
        }
    }
    
    func showBanner(title: String?=nil, detail: String?=nil, type: BannerType?=nil) {
        DispatchQueue.main.async {
            endEditing()
            if let theTitle = title {self.title = theTitle}
            if let theDetail = detail {self.detail = theDetail}
            if let theType = type {self.bannerType = theType}
            self.showBannerMessge = true
        }
    }
    
    func showToast(title: String?=nil, image: String?=nil) {
        DispatchQueue.main.async {
            endEditing()
            if let theTitle = title {self.title = theTitle}
            if let theImage = image {self.image = theImage}
            self.showToastMessage = true
        }
    }
}
