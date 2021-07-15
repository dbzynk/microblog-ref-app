//
//  SearchTabView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 31.05.2021.
//

import SwiftUI

struct SearchTabView: View {
    @State var searchText = ""
    @ObservedObject var viewModel = SearchViewModel(config: .search)
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchBar(text: $searchText)
                    .padding()
                    .onChange(of: searchText, perform: { newSearchText in
                        DispatchQueue.main.async {
                            viewModel.fetchUsers(by: newSearchText)
                        }
                    })
                
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.users, id: \.self) { user in
                            NavigationLink(
                                destination: LazyView(UserProfileView(user: user)),
                                label: {
                                    HStack {
                                        UserCell(user: user)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                })
                            Divider()
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Search", displayMode: .inline)
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTabView()
    }
}
