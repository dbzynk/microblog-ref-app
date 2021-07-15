//
//  DynamicTextAreaView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 26.06.2021.
//

import SwiftUI

struct DynamicTextAreaView: View {
    
    @Binding var text: String
    var placeholder = "Text..."
    var lineLimit: Int? = nil
    
    init(text: Binding<String>, placeholder:String?=nil, lineLimit: Int?=nil) {
        if let placeholder = placeholder { self.placeholder = placeholder }
        self._text = text
        self.lineLimit = lineLimit
        UITextView.appearance().backgroundColor = .clear
    }
    
    @State private var labelHeight : CGFloat = 35
    var body: some View {
        ZStack(alignment: .leading) {
            Text(text.isEmpty ? placeholder : text).foregroundColor(Color(.clear))
                .padding(.vertical, 10)
                .lineLimit(lineLimit)
                .background(GeometryReader {
                    Color(.clear).preference(key: ViewHeightKey.self, value:  $0.frame(in: .local).size.height)
                })
                .onPreferenceChange(ViewHeightKey.self) { value in
                    DispatchQueue.main.async {
                        labelHeight = value
                    }
                }

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 4)
                    .padding(.bottom, 3)
            }
            
            TextEditor(text: $text)
                .frame(maxHeight: labelHeight)
        }
        .padding(.horizontal, 4)
        .font(.body)
        
    }
    
    struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }
}

struct DynamicTextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicTextAreaView(text: .constant(""))
    }
}
