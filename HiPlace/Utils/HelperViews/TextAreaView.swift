//
//  TextAreaView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct TextAreaView: View {
    
    let placeholder: String
    @Binding var text: String
    
    init(placeholder:String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $text)
                .padding(4)
        }
        .font(.body)
    }
}

struct TextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaView(placeholder: "placeholder", text: .constant(""))
    }
}
