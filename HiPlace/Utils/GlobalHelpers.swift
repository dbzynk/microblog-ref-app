//
//  GlobalHelpers.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI
import Kingfisher

var huaweiToken: String? = nil

extension UIColor {
    static let primary = #colorLiteral(red: 0.2516767979, green: 0.4673609138, blue: 0.2600513697, alpha: 1)
    static let accent = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}

func endEditing() {
    UIApplication.shared.windows.forEach { $0.endEditing(true)}
}

