//
//  HomeTabView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 31.05.2021.
//

import SwiftUI

struct HomeTabView: View {
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                FeedView()
                    .navigationBarTitle("Home", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        showingAlert = true

                    }, label: {
                        AlertView(title: "Sign Out", message: "Do you really want to sign out?", primaryButton: "Sign Out", showAlert:  $showingAlert) {
                            ProfileImageView(showAuthenticatedUser: true)
                        }
                        primaryButtonAction: {
                            AuthService.shared.signOut()
                        }
                    })
                    )
                
                    
                
            }
        }
        
    }
    
    
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}

