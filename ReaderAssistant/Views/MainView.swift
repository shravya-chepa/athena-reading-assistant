//
//  ContentView.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = VoiceAssistantViewModel()
    
    var body: some View {
        VStack(spacing:20) {
            Text(viewModel.transcript.isEmpty ? "Press the mic" : viewModel.transcript)
                .padding()
            
            Button(action: {
                viewModel.toggleListening()
            }) {
                Image(systemName: viewModel.isListening ? "mic.fill" : "mic")
                    .resizable()
                    .frame(width: 50, height: 70)
                    .padding()
                    .foregroundColor(viewModel.isListening ? .red : .blue)
            }
        }
    }
}

#Preview {
    MainView()
}

