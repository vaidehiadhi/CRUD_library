//
//  library_client.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 28/06/24.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

class LibraryClient {
    private let channel: ClientConnection
    private let client: Library_LibraryServiceNIOClient

    init(host: String, port: Int) {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        channel = ClientConnection.insecure(group: group)
            .connect(host: host, port: port)
        client = Library_LibraryServiceNIOClient(channel: channel)
    }

    func createBook(title: String, author: String, completion: @escaping (Result<Library_Book, Error>) -> Void) {
        let book = Library_Book.with {
            $0.title = title
            $0.author = author
        }
        let request = Library_CreateBookRequest.with {
            $0.book = book
        }
        client.createBook(request).response.whenComplete { result in
            switch result {
            case .success(let response):
                completion(.success(response.book))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getBook(id: String, completion: @escaping (Result<Library_Book, Error>) -> Void) {
        let request = Library_GetBookRequest.with {
            $0.id = id
        }
        client.getBook(request).response.whenComplete { result in
            completion(result)
        }
    }

    func updateBook(id: String, title: String, author: String, completion: @escaping (Result<Library_Book, Error>) -> Void) {
        let book = Library_Book.with {
            $0.bid = id
            $0.title = title
            $0.author = author
        }
        let request = Library_UpdateBookRequest.with {
            $0.id = id
            $0.book = book
        }
        client.updateBook(request).response.whenComplete { result in
            completion(result)
        }
    }

    func deleteBook(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = Library_DeleteBookRequest.with {
            $0.id = id
        }
        client.deleteBook(request).response.whenComplete { result in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func listBooks(completion: @escaping (Result<[Library_Book], Error>) -> Void) {
        let request = Library_ListBooksRequest()
        client.listBooks(request).response.whenComplete { result in
            switch result {
            case .success(let response):
                completion(.success(response.books))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func shutdown() {
        try? channel.close().wait()
    }
}
