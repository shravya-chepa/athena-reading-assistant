////
////  WakeWordService.swift
////  ReaderAssistant
////
////  Created by Shravya Chepa on 9/21/25.
////
//
//import Foundation
//import AVFoundation
//import Porcupine
//
//class WakeWordService {
//    private var porcupine: Porcupine?
//    private let audioEngine = AVAudioEngine()
//    private let keywordCallback: () -> Void
//    
//    init?(keywordCallback: @escaping () -> Void) {
//        self.keywordCallback = keywordCallback
//        
//        guard let accessKey = Bundle.main.object(forInfoDictionaryKey: "PICOVOICE_ACCESS_KEY") as? String else {
//            print("ERROR: PICOVOICE_ACCESS_KEY not found in Info.plist")
//            return nil
//        }
//        
//        do {
//            porcupine = try Porcupine(
//                accessKey: accessKey,
//                keywordPath: Bundle.main.path(forResource: "Athena_en_ios_v3_0_0", ofType: "ppn")!
//            )
//        } catch {
//            print("WakeWordService init error: \(error)")
//            return nil
//        }
//    }
//    
//    func start() {
//        guard let porcupine = porcupine else { return }
//        
//        let inputNode = audioEngine.inputNode
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        
//        inputNode.installTap(onBus: 0, bufferSize: 512, format: recordingFormat) { buffer, _ in
//            guard let channelData = buffer.int16ChannelData else { return }
//            let frameLength = Int(buffer.frameLength)
//            let samples = Array(UnsafeBufferPointer(start: channelData[0], count: frameLength))
//            
//            do {
//                let keywordIndex = try porcupine.process(pcm: samples)
//                if keywordIndex >= 0 {
//                    print("Wake word detected!")
//                    DispatchQueue.main.async {
//                        self.keywordCallback()
//                    }
//                }
//            } catch {
//                print("Porcupine process error: \(error)")
//            }
//        }
//        
//        do {
//            try audioEngine.start()
//            print("WakeWordService started")
//        } catch {
//            print("WakeWordService failed to start: \(error)")
//        }
//    }
//    
//    func stop() {
//        audioEngine.stop()
//        audioEngine.inputNode.removeTap(onBus: 0)
//        print("WakeWordService stopped")
//    }
//}
