//
//  AlertView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 11.07.2021.
//
import SwiftUI

struct AlertView<Content: View>: View {
    var title: String
    var message: String
    
    var primaryButton = "OK"
    var secondaryButton = "Cancel"
    
    @Binding var showAlert: Bool
    var content: () -> Content
    var primaryButtonAction : ()->Void
    var secondaryButtonAction : (()->Void)?


   
    var body: some View {
            Button(action: {
                self.showAlert = true
            }) {
                content()
            }
            .alert(isPresented: $showAlert) { () -> Alert in

                if let secondaryButtonAction = secondaryButtonAction {
                    return Alert(title: Text(title), message: Text(message), primaryButton: .default(Text(primaryButton), action: primaryButtonAction), secondaryButton: .default(Text(secondaryButton), action: secondaryButtonAction))
                } else {
                    return Alert(title: Text(title), message: Text(message), primaryButton: .default(Text(primaryButton), action: primaryButtonAction), secondaryButton: .default(Text(secondaryButton)))
                }
                
        }

    }
}
