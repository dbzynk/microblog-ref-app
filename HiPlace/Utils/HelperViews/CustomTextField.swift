//
//  CustomTextField.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    var placeholder: String
    var imageName: String = ""

    var horizontalSpacing: CGFloat = 16
    var isSecure: Bool = false
    var textContentType: UITextContentType? = .none
    var textAutoCapitalizationType: UITextAutocapitalizationType = .sentences

    private let imageWidth = 20
    private let capsuleWidth = 2
        
    private var leadingPadding : CGFloat {
        if !imageName.isEmpty {
            let totalLeading = Int(horizontalSpacing) * 2 + imageWidth + capsuleWidth
            return CGFloat(totalLeading)
        }
        return 0
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .padding(.leading, leadingPadding)
            }
            
            HStack(spacing: horizontalSpacing){
                if !imageName.isEmpty {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Capsule()
                        .frame(width: 2, height: 25)
                 
                }

                if isSecure {
                    SecureField("",text: $text)
                        .textContentType(.password)
                } else {
                TextField("",text: $text)
                    .textContentType(textContentType)
                    .autocapitalization(textAutoCapitalizationType)
                }
            }
            
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.darkGray)
            CustomTextField(text: .constant(""), placeholder: "Email", imageName: "envelope")
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .padding(.horizontal)
            
                .foregroundColor(.white)
        }

    }
}
