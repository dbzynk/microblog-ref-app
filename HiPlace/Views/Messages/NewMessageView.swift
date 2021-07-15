//
//  NewMessageView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 3.06.2021.
//

import SwiftUI

struct NewMessageView: View {
    @State var searchText = ""
    @Binding var show: Bool
    @Binding var isStartChat: Bool
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    @Binding var user: UserInfo?

    var body: some View {
        ScrollView {
            SearchBar(text: $searchText)
                .onChange(of: searchText, perform: { newSearchText in
                    DispatchQueue.main.async {
                        viewModel.fetchUsers(by: newSearchText)
                    }
                })
                .padding()
            
            
            HStack {
                VStack(alignment: .leading) {
                    ForEach(viewModel.users, id: \.self) { user in
                        Button(action: {
                            self.user = user
                            self.show.toggle()
                            self.isStartChat.toggle()
                        }, label: {
                            UserCell(user: user)
                        })
                    }
                }
                .padding(.leading)
                Spacer()
            }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView(show: .constant(true), isStartChat: .constant(true), user: .constant(UserInfo()))
    }
}
