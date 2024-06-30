//
//  ContentView.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 30/06/24.
//

import SwiftUI

struct contentView: View {  // Changed from 'contentView' to 'ContentView'
    @StateObject private var viewModel = LibraryViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                VStack(alignment: .leading) {
                    Text(book.title).font(.headline)
                    Text(book.author).font(.subheadline)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200, idealWidth: 250, maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Library")  // Moved inside NavigationView
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
