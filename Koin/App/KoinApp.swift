//  KoinApp.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI
import SwiftData

@main
struct KoinApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Transaction.self])
    }
}
