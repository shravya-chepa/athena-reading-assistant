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
        
    }
}

#Preview {
    MainView()
}

