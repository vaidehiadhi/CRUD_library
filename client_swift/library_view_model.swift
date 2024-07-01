//
//  library_view_model.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 30/06/24.
//

import Foundation
import Combine
import SwiftUI

@MainActor
public class LibraryViewModel: ObservableObject {
    @Published public var books: [Book] = []
    private let client: LibraryClient

    public init(mockBooks: [Book] = []) {
        self.client = LibraryClient(host: "localhost", port: 50051)
        if !mockBooks.isEmpty {
            self.books = mockBooks
        }
    }

    public func fetchBooks() {
        client.listBooks { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let books):
                    self?.books = books.map { Book(id: $0.bid, title: $0.title, author: $0.author) }
                case .failure(let error):
                    print("Error fetching books: \(error)")
                }
            }
        }
    }

    public func addBook(title: String, author: String) {
        client.createBook(title: title, author: author) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let book):
                    self?.books.append(Book(id: book.bid, title: book.title, author: book.author))
                case .failure(let error):
                    print("Error creating book: \(error)")
                }
            }
        }
    }

    public func runClientDemo() {
        createBook(title: "Swift Programming", author: "Apple")
    }

    private func createBook(title: String, author: String) {
        client.createBook(title: title, author: author) { [weak self] result in
            switch result {
            case .success(let book):
                print("Book created: \(book.title) by \(book.author) with ID: \(book.bid)")
                self?.getBook(id: book.bid)
            case .failure(let error):
                print("Error creating book: \(error)")
            }
        }
    }

    private func getBook(id: String) {
        client.getBook(id: id) { [weak self] result in
            switch result {
            case .success(let book):
                print("Fetched book: \(book.title) by \(book.author)")
                self?.updateBook(id: book.bid, title: "Advanced Swift", author: "Apple Inc.")
            case .failure(let error):
                print("Error fetching book: \(error)")
            }
        }
    }

    private func updateBook(id: String, title: String, author: String) {
        client.updateBook(id: id, title: title, author: author) { [weak self] result in
            switch result {
            case .success(let book):
                print("Updated book: \(book.title) by \(book.author)")
                self?.listBooks()
            case .failure(let error):
                print("Error updating book: \(error)")
            }
        }
    }

    private func listBooks() {
        client.listBooks { [weak self] result in
            switch result {
            case .success(let books):
                print("All books:")
                for book in books {
                    print("- \(book.title) by \(book.author)")
                }
                if let firstBook = books.first {
                    self?.deleteBook(id: firstBook.bid)
                }
            case .failure(let error):
                print("Error listing books: \(error)")
            }
        }
    }

    private func deleteBook(id: String) {
        client.deleteBook(id: id) { result in
            switch result {
            case .success(let success):
                print("Book deleted: \(success)")
            case .failure(let error):
                print("Error deleting book: \(error)")
            }
        }
    }
}

public struct Book: Identifiable {
    public let id: String
    public let title: String
    public let author: String
    
    public init(id: String, title: String, author: String) {
        self.id = id
        self.title = title
        self.author = author
    }
}
