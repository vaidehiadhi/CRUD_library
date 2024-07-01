//
//  ContentView.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 01/07/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: LibraryViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author)
                        .font(.subheadline)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200, idealWidth: 250, maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Library")
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            viewModel.fetchBooks()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LibraryViewModel(mockBooks: [
            Book(id: "1", title: "To Kill a Mockingbird", author: "Harper Lee"),
            Book(id: "2", title: "1984", author: "George Orwell")
        ]))
}
