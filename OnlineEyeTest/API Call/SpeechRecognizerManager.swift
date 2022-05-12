//
//  SpeechRecognizerManager.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 11/5/2022.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

class SpeechRecognizerManager: ObservableObject {
    static let shared = SpeechRecognizerManager()
    
    @Published var speechRecognizers: [SpeechRecognizer] = []
    
    func push(_ speechRecognizer: SpeechRecognizer) {
        self.speechRecognizers.append(speechRecognizer)
        print("SpeechRecognizerManager: pushed. count: \(speechRecognizers.count)")
    }
    
    func pop(_ speechRecognizer: SpeechRecognizer) {
        let index = self.speechRecognizers.firstIndex(where: { $0.id == speechRecognizer.id })
        if let index = index {
            self.speechRecognizers.remove(at: index)
            print("SpeechRecognizerManager: popped. count: \(speechRecognizers.count)")
        } else {
            print("SpeechRecognizerManager: failed to pop")
        }
    }
    
    func stopAll() {
        if self.speechRecognizers.count > 0 {
            for speechRecognizer in speechRecognizers {
                speechRecognizer.stop(soundAndHapticEnabled: false)
            }
        }
        print("SpeechRecognizerManager: stopAll")
    }
}
