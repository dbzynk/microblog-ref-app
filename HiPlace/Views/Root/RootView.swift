//
//  RootView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 31.05.2021.
//

import SwiftUI
import Kingfisher

struct RootView: View {
    init() {
        // UINavigationBar.appearance().titleTextAttributes =  [.foregroundColor : UIColor.systemGreen]
    }
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        ZStack {
            if authService.userSession != nil {
                TabView {
                    HomeTabView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    SearchTabView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    
                    MessagesTabView()
                        .tabItem {
                            Label("Messages", systemImage: "envelope")
                        }
                }
                .accentColor(Color(.systemGreen))
            } else {
                LoginView()
            }
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            
    }
}
