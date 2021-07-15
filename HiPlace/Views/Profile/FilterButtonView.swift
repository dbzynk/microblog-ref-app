//
//  FilterButtonView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

enum FilterOptions : Int, CaseIterable {
    case posts
   // case replies
    case liked
    
    var title: String {
        switch self {
        case .posts: return "Posts"
       // case .replies: return "Posts & Replies"
        case .liked: return "Liked"
        }
    }
}

struct FilterButtonView: View {
    @Binding var selectedOption: FilterOptions
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(FilterOptions.allCases.count)

    private func padding(_ geometry: GeometryProxy) -> CGFloat {
        let rawValue = CGFloat(selectedOption.rawValue)
        let count = CGFloat(FilterOptions.allCases.count)
        return ((geometry.size.width / count) * rawValue) + 16
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    ForEach(FilterOptions.allCases, id: \.self) { option in
                        Button(action: {
                            self.selectedOption = option
                        }, label: {
                            Text(option.title)
                                .bold()
                                .frame(width: geometry.size.width / CGFloat(FilterOptions.allCases.count))
                                .foregroundColor(Color(.systemGreen))
                        })
                    }
                }
                
                Rectangle()
                    .frame(width: (geometry.size.width / CGFloat(FilterOptions.allCases.count)) - 32, height: 3, alignment: .center)
                    .foregroundColor(Color(.systemGreen))
                    .padding(.leading, padding(geometry))
                    .animation(.spring())
            }
        }
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonView(selectedOption: .constant(.posts))
    }
}
