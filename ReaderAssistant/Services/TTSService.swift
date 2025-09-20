//
//  TTSService.swift
//  ReaderAssistant
//
//  Created by Shravya Chepa on 9/20/25.
//

import Foundation
import AVFoundation

class TTSService {
    private let synthesizer = AVSpeechSynthesizer()
    private var delegateWrapper: SpeechDelegateWrapper?
    
    func speak(text: String, onFinish: (() -> Void)? = nil) {
        print("TTS service about to speak: \(text)")
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.duckOthers, .defaultToSpeaker])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set audio session for tts")
        }
        
        
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        // call when done speaking
        let wrapper = SpeechDelegateWrapper(onFinish: onFinish)
        delegateWrapper = wrapper
        synthesizer.delegate = wrapper
        synthesizer.speak(utterance)
    }
}

private class SpeechDelegateWrapper: NSObject, AVSpeechSynthesizerDelegate {
    private let onFinish: (() -> Void)?
    
    init(onFinish: (() -> Void)?) {
        self.onFinish = onFinish
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart speaking: \(utterance.speechString)")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish speaking: \(utterance.speechString)")
        onFinish?()
    }
}
