//
//  LazyView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 22.06.2021.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

