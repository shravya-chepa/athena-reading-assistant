//
//  ContentView.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: VoiceAssistantViewModel
    @StateObject private var storageVM = QAStorageViewModel()
    
    init() {
        let storage = QAStorageViewModel()
        _storageVM = StateObject(wrappedValue: storage)
        _viewModel = StateObject(wrappedValue: VoiceAssistantViewModel(storageVM: storage))
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                // conversation tab
                ConversationView(viewModel: viewModel)
                    .tabItem {
                        Label("Chat", systemImage: "mic.fill")
                    }
                
                // history tab
                HistoryView(storageVM: storageVM)
                    .tabItem {
                        Label("History", systemImage: "book.fill")
                    }
            }
            .navigationTitle("Athena")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // placeholder for future menu/settings button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // todo: menu section
                    }) {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}

