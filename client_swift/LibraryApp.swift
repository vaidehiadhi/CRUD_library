//
//  LibraryApp.swift
//  client_swift
//
//  Created by Vaidehi Adhi on 01/07/24.
//

import SwiftUI

struct LibraryApp: App {
    @StateObject private var viewModel = LibraryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
    }
}

