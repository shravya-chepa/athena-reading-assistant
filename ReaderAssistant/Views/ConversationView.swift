//
//  ConversationView.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/21/25.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var viewModel: VoiceAssistantViewModel
    
    var body: some View {
        VStack(spacing:20) {
            ScrollView{
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(viewModel.conversation.enumerated()), id: \.offset) {
                        _, entry in
                        Text("\(entry.speaker): \(entry.text)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
            }
            
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
