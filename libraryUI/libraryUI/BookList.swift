//
//  BookList.swift
//  libraryUI
//
//  Created by Vaidehi Adhi on 03/07/24.
//

import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
}

struct BookList: View {
    @State private var books: [Book] = [
        Book(title: "1984", author: "George Orwell"),
        Book(title: "To Kill a Mockingbird", author: "Harper Lee")
    ]
    
    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: BookDetail(book: book)) {
                    VStack(alignment: .leading) {
                        Text(book.title).font(.headline)
                        Text(book.author).font(.subheadline)
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddBook(books: $books)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
