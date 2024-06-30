//
//  main.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 29/06/24.
//

import Foundation
import Dispatch

let client = LibraryClient(host: "localhost", port: 50051)
let group = DispatchGroup()

func runClientDemo() {
    group.enter()
    
    // Create a book
    client.createBook(title: "Norweigien Wood", author: "Murakami") { result in
        switch result {
        case .success(let book):
            print("Book created: \(book.title) by \(book.author) with ID: \(book.bid)")
            
            // Get the created book
            client.getBook(id: book.bid) { result in
                switch result {
                case .success(let fetchedBook):
                    print("Fetched book: \(fetchedBook.title) by \(fetchedBook.author)")
                    
                    // Update the book
                    client.updateBook(id: book.bid, title: "Good Girl's Guide to Murder", author: "Holly Jackson") { result in
                        switch result {
                        case .success(let updatedBook):
                            print("Updated book: \(updatedBook.title) by \(updatedBook.author)")
                            
                            // List all books
                            client.listBooks { result in
                                switch result {
                                case .success(let books):
                                    print("All books:")
                                    for book in books {
                                        print("- \(book.title) by \(book.author)")
                                    }
                                    
                                    // Delete the book
                                    client.deleteBook(id: book.bid) { result in
                                        switch result {
                                        case .success(let success):
                                            print("Book deleted: \(success)")
                                        case .failure(let error):
                                            print("Error deleting book: \(error)")
                                        }
                                        group.leave()
                                    }
                                case .failure(let error):
                                    print("Error listing books: \(error)")
                                    group.leave()
                                }
                            }
                        case .failure(let error):
                            print("Error updating book: \(error)")
                            group.leave()
                        }
                    }
                case .failure(let error):
                    print("Error fetching book: \(error)")
                    group.leave()
                }
            }
        case .failure(let error):
            print("Error creating book: \(error)")
            group.leave()
        }
    }
}

runClientDemo()

group.notify(queue: .main) {
    print("All operations completed")
    client.shutdown()
    exit(0)
}

dispatchMain()
