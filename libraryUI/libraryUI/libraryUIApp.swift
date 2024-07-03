//
//  libraryUIApp.swift
//  libraryUI
//
//  Created by Vaidehi Adhi on 03/07/24.
//

import SwiftUI

@main
struct libraryUIApp: App {
    init() {
      
        GRPCDemo.runClientDemo {
            print("GRPC Demo completed")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
