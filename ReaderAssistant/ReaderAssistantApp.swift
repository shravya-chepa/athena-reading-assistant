//
//  ReaderAssistantApp.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import SwiftUI
import FirebaseCore

@main
struct ReaderAssistantApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
