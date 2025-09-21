//
//  VoiceAssistantViewModel.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//
import Foundation
import Combine

class VoiceAssistantViewModel: ObservableObject {
    private let speechService = SpeechService()
    private let ttsService = TTSService()
    private let nlpService = NLPService()
    private let storageVM: QAStorageViewModel
    
    @Published var transcript: String = ""
    @Published var answer: String = ""
    @Published var isListening: Bool = false
    @Published var isSpeaking: Bool = false
    @Published var conversation: [(speaker: String, text: String)] = []
    
    // Store the final transcript to prevent it from being lost
    private var finalTranscript: String = ""
    private var lastPartialResult: String = ""
    // to store if the speech is already processed then we don't need to speak again
    private var hasProcessedResult: Bool = false
    
    init(storageVM: QAStorageViewModel) {
        self.storageVM = storageVM
        speechService.requestAuthorization()
    }
    
    func toggleListening() {
        if isListening {
            // When manually stopping, use the last partial result
            let textToUse = lastPartialResult.trimmingCharacters(in: .whitespacesAndNewlines)
            
            speechService.stopListening()
            isListening = false
            hasProcessedResult = true  // Mark that we're handling the result
            
            if !textToUse.isEmpty {
                finalTranscript = textToUse
                print("DEBUG ViewModel: Using partial result as final: '\(finalTranscript)'")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.handleQuery()
                }
            } else {
                print("DEBUG ViewModel: No partial text to use")
            }
        } else {
            startListening()
        }
    }
    
    private func startListening() {
        // Reset state
        finalTranscript = ""
        lastPartialResult = ""
        hasProcessedResult = false  // Reset the flag
        
        do {
            try speechService.startListening { [weak self] text, isFinal in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    print("DEBUG ViewModel: Received text: '\(text)', isFinal: \(isFinal)")
                    
                    // Always update the displayed transcript
                    self.transcript = text
                    
                    if !isFinal {
                        // Store partial results
                        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            self.lastPartialResult = text
                        }
                    } else {
                        // Only process final result if we haven't already handled it manually
                        guard !self.hasProcessedResult else {
                            print("DEBUG ViewModel: Ignoring final result - already processed manually")
                            return
                        }
                        
                        // Handle natural final result (not from manual cancellation)
                        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            self.finalTranscript = text
                            print("DEBUG ViewModel: Natural final transcript: '\(self.finalTranscript)'")
                        } else {
                            // Final result is empty (probably due to cancellation), use last partial
                            self.finalTranscript = self.lastPartialResult
                            print("DEBUG ViewModel: Empty final result, using partial: '\(self.finalTranscript)'")
                        }
                        
                        // Stop listening
                        self.speechService.stopListening()
                        self.isListening = false
                        self.hasProcessedResult = true  // Mark as processed
                        
                        // Only speak if we actually have text
                        if !self.finalTranscript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            // Small delay to ensure audio session transition
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.handleQuery()
                            }
                        } else {
                            print("DEBUG ViewModel: No text to speak - final transcript is empty")
                        }
                    }
                }
            }
            isListening = true
        } catch {
            print("Error starting speech recognition: \(error.localizedDescription)")
        }
    }
    
//    private func speakFinalText() {
//        let textToSpeak = finalTranscript.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard !textToSpeak.isEmpty else {
//            print("DEBUG ViewModel: No text to speak")
//            return
//        }
//
//        print("DEBUG ViewModel: About to speak: '\(textToSpeak)' (length: \(textToSpeak.count))")
//
//        isSpeaking = true
//        ttsService.speak(text: textToSpeak) { [weak self] in
//            DispatchQueue.main.async {
//                self?.isSpeaking = false
//                print("DEBUG ViewModel: Finished speaking")
//            }
//        }
//    }
    
    private func handleQuery() {
        let query = finalTranscript
        print("DEBUG ViewModel: Sending query to NLPService: \(query)")
        
        // append user turn
        conversation.append((speaker: "You", text: query))
        
        nlpService.process(query: query) {
            [weak self] result in
            DispatchQueue.main.async {
                
                guard let self = self, let result = result else { return }
                
                self.answer = result.answer // save processed answer
                print("DEBUG ViewModel: NLP answer =  \(result.answer)")
                
                // append assistant turn
                self.conversation.append((speaker: "Assistant", text: result.answer))
                
                // save entry in storage
                let category: String
                var questionToSave = query
                
                switch result.source {
                case .dictionary(let word):
                    category = "word"
                    questionToSave = word
                case .llm: category = "general"
                case .goodbye: category = "exit"
                case .unknown: category = "misc"
                }
                
                self.storageVM.addEntry(
                    question: questionToSave,
                    answer: result.answer,
                    category: category
                )
                
                self.isSpeaking = true
                self.ttsService.speak(text: self.answer) {
                    DispatchQueue.main.async {
                        self.isSpeaking = false
                        print("DEBUG ViewModel: Finished speaking")
                    }
                }
                
            }
        }
    }
}
