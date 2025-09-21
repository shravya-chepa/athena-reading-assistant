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
        VStack(spacing:12) {
            ScrollView{
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(viewModel.conversation.enumerated()), id: \.offset) {
                        _, entry in
                        HStack {
                            if entry.speaker == "You" {
                                Spacer()
                                Text(entry.text)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(entry.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250, alignment: .leading)
                            Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            
            Text(viewModel.transcript.isEmpty ? "Press the mic and start speaking" : viewModel.transcript)
//                            .padding()
            
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
        .padding(.bottom, 30)
    }
}
