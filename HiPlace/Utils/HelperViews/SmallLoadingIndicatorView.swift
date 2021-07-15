//
//  SmallLoadingIndicatorView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 27.06.2021.
//

import SwiftUI

struct SmallLoadingIndicatorView: View {
    var body: some View {
        ZStack {
            
            Color(.label).colorInvert().opacity(0.4).ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(.label)))
                .scaleEffect(2)
        }
    }
}

struct SmallLoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        SmallLoadingIndicatorView()
    }
}
