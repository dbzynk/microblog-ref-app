//
//  CustomCorderRadiusShape.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 26.06.2021.
//

import SwiftUI

struct CustomCorderRadiusShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CustomCorderRadiusShape_Previews: PreviewProvider {
    static var previews: some View {
        CustomCorderRadiusShape(corners: [.allCorners], radius: 8)
    }
}
