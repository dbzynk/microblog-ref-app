//
//  SearchBar.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 1.06.2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                              .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.leading , 8)
                )
        }
        .padding(.horizontal, 10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("Hello"))
    }
}
