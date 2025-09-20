//
//  SpeechService.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//
import Foundation
import Speech
import AVFoundation

class SpeechService {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // request authorization
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // handle authorization status on the main queue
            
            OperationQueue.main.addOperation {
                
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorization granted")
                case .denied:
                    print("Speech recognition authorization is denied")
                case .restricted:
                    print("Speech recognition restricted on this device")
                case .notDetermined:
                    print("Speech recognition not determined")
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
    }
    
    func startListening(onText: @escaping (String, Bool) -> Void ) throws {
        
        // cancel any previous tasks to ensure a fresh session
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputMode = audioEngine.inputNode
        inputMode.removeTap(onBus: 0)
        
        // create a new recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "SpeechService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create a SFSpeechAudioBufferRecognitionRequest object."])
        }
        
        // tell the request to report partial results
        recognitionRequest.shouldReportPartialResults = true
        
        // start the recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            
            var isFinal = false
            var transcribedText = ""
            
            if let result = result {
                transcribedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
                
                print("DEBUG SpeechService: transcription = '\(transcribedText)', isFinal: \(isFinal)")
                
                // Call the callback with the transcribed text BEFORE any cleanup
                onText(transcribedText, isFinal)
            }
            
            if let error = error {
                let nsError = error as NSError
                // Code 301 means the request was cancelled, which is expected when we stop listening
                if nsError.code != 301 {
                    print("Speech recognition error: \(error)")
                }
                // Don't cleanup here - let stopListening handle it
            }
        }
        
        // set up the tap on the audio engine's input node
        let recordingFormat = inputMode.outputFormat(forBus: 0)
        inputMode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        // prepare and start the audio engine
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopListening() {
        cleanup()
        
        // deactivate record session so playback can take over
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            print("Mic session deactivated, ready for playback")
        } catch {
            print("Failed to deactivate session: \(error)")
        }
    }
    
    private func cleanup() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
}
