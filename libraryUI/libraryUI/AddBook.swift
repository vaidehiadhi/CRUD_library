//
//  AddBook.swift
//  libraryUI
//
//  Created by Vaidehi Adhi on 03/07/24.
//

import SwiftUI

struct AddBook: View {
    @Binding var books: [Book]
    @State private var title = ""
    @State private var author = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Author", text: $author)
            Button("Add Book") {
                let newBook = Book(title: title, author: author)
                books.append(newBook)
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(title.isEmpty || author.isEmpty)
        }
        .navigationTitle("Add Book")
    }
}
