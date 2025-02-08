//
//  SearchView.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 26.01.25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    //    var filteredUsers:[String]
    //    {
    //        if userID.isEmpty {
    //            return []
    //        }
    //        else{
    //            return [].filter( $0.localisedCaseInsensitiveContains(userID))
    //        }
    //    }
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    // to do search for specific search requerements and add them to addchatview and add groupchatview
    //look up messaging logic/views

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    var body: some View {
        ScrollView {
            CustomTextField_Circle(icon: "magnifyingglass", prompt: "Search user...", value: $searchText)
                .padding()
            LazyVStack(spacing: 12) {
                ForEach(0 ... 10, id: \.self) { user in
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("username")
                                .fontWeight(.semibold)
                            Text("nickname")
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "Search...")
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchView()
}
