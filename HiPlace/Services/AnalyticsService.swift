//
//  AnalyticsService.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 12.07.2021.
//

import Foundation
import HiAnalytics

class AnalyticsService {
    
    private init() {}
    static let shared = AnalyticsService()
    
    func onEvent(_ eventId: String, setParams params: [String : Any]) {
        HiAnalytics.onEvent(eventId, setParams: params)
    }
    func setUserProfile(_ name: String, setValue value: String?) {
        HiAnalytics.setUserProfile(name, setValue: value)
    }
}
