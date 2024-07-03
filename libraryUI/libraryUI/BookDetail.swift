//
//  BookDetail.swift
//  libraryUI
//
//  Created by Vaidehi Adhi on 03/07/24.
//

import SwiftUI

struct BookDetail: View {
    let book: Book
    
    var body: some View {
        VStack(spacing: 20) {
            Text(book.title).font(.title)
            Text(book.author).font(.headline)
            Spacer()
        }
        .padding()
        .navigationTitle("Book Details")
    }
}
