//
//  LoadingIndicatorView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 5.06.2021.
//

import SwiftUI

struct LoadingIndicatorView: View {
    
    @Binding var showIndicator: Bool
    @State private var isLoading = false
    var width: CGFloat = 80
 
    var body: some View {
        if showIndicator {
            HStack {
            Spacer()
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color(.gray), lineWidth: 7)
                        .frame(width: width, height: width)
         
                    Circle()
                        .trim(from: 0, to: 0.2)
                        .stroke(Color(.init(white: 1, alpha: 0.7)), lineWidth: 5)
                        .frame(width: width, height: width)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .onAppear() {
                            self.isLoading = true
                    }
                                        
                    Circle()
                        .trim(from: 0, to: 0.2)
                        .stroke(Color(.init(white: 1, alpha: 0.4)), lineWidth: 5)
                        .frame(width: width, height: width)
                        .rotationEffect(Angle(degrees: 90))
                        .rotationEffect(Angle(degrees: isLoading ? 0 : 360))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .onAppear() {
                            self.isLoading = true
                    }
                    
                }
                .rotationEffect(Angle(degrees: 45))
                Spacer()
            }
            Spacer()
        }
            .background(Color.black.opacity(0.4))
            .ignoresSafeArea()
            .zIndex(99)
        }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(showIndicator: .constant(true))
    }
}
