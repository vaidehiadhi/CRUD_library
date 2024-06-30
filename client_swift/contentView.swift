//
//  contentView.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 30/06/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = LibraryViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                VStack(alignment: .leading) {
                    Text(book.title).font(.headline)
                    Text(book.author).font(.subheadline)
                }
            }
            .navigationTitle("Library")
        }
    }
}

struct contentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
