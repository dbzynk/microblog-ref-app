//
//  ProgressBar.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    var width: CGFloat = 200
    var height: CGFloat = 200
    var lineWidth: CGFloat = 20
    var text: String = ""
    var color = Color.white

    var getText: String {
        if self.text.isEmpty {
           return String(format: "%.0f %%", min(self.progress, 1.0)*100.0)
        }
        return text
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(color)
                .frame(width: width, height: height)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .frame(width: width, height: height)

            Text(getText)
                .font(.largeTitle)
                .bold()
        }
        .padding()
    }
}
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: .constant(0.4))
    }
}
