//
//  ContentView.swift
//  libraryUI
//
//  Created by Vaidehi Adhi on 03/07/24.
//

import SwiftUI
import GRPC

struct ContentView: View {
    @State private var books: [Library_Book] = []
    @State private var newBookTitle = ""
    @State private var newBookAuthor = ""
    
    let client = LibraryClient(host: "localhost", port: 50051)
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(books, id: \.bid) { book in
                        VStack(alignment: .leading) {
                            Text(book.title).font(.headline)
                            Text(book.author).font(.subheadline)
                        }
                    }
                    .onDelete(perform: deleteBook)
                }
                
                HStack {
                    TextField("Title", text: $newBookTitle)
                    TextField("Author", text: $newBookAuthor)
                    Button("Add") {
                        addBook()
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
            .onAppear(perform: fetchBooks)
        }
    }
    
    func fetchBooks() {
        client.listBooks { result in
            switch result {
            case .success(let grpcBooks):
                self.books = grpcBooks
            case .failure(let error):
                print("Failed to fetch books: \(error)")
            }
        }
    }
    
    func addBook() {
        client.createBook(title: newBookTitle, author: newBookAuthor) { result in
            switch result {
            case .success(let book):
                self.books.append(book)
                self.newBookTitle = ""
                self.newBookAuthor = ""
            case .failure(let error):
                print("Failed to add book: \(error)")
            }
        }
    }
    
    func deleteBook(at offsets: IndexSet) {
        for index in offsets {
            let book = books[index]
            client.deleteBook(id: book.bid) { result in
                switch result {
                case .success(_):
                    if let index = self.books.firstIndex(where: { $0.bid == book.bid }) {
                        self.books.remove(at: index)
                    }
                case .failure(let error):
                    print("Failed to delete book: \(error)")
                }
            }
        }
    }
}
