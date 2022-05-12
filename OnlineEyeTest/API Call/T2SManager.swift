//
//  File.swift
//  Calibration
//
//  Created by Keane Hui on 7/3/2022.
//

import Foundation
import AVFoundation
import SwiftUI

class T2SManager: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    static let shared = T2SManager()
    var enabled: Bool {
        Setting.shared.VI_enabled
    }
    
    @Published var isSpeaking: Bool = false
    
    var synthesizer: AVSpeechSynthesizer?
    var utterance: AVSpeechUtterance?
    var rate: Float {
        Setting.shared.VI_speed
    }
    var pitchMultiplier: Float {
        Setting.shared.VI_pitch
    }
    var voice: AVSpeechSynthesisVoice?
    
    var onStart: (() -> Void)?
    var onComplete: (() -> Void)?
    
    override init() {
        super.init()
        self.voice = AVSpeechSynthesisVoice(identifier: getVoiceId())
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category. \(error.localizedDescription)")
        }
    }
    
    func speakSentence(_ sentence: String, delay: Double? = 0.0, onStart: (() -> Void)? = nil, onComplete: (() -> Void)? = nil) {
        if !enabled {
            return
        }
        self.utterance = nil
        self.utterance = AVSpeechUtterance(string: sentence)
        self.utterance!.preUtteranceDelay = delay ?? 0.0
        self.utterance!.rate = self.rate
        self.utterance!.pitchMultiplier = self.pitchMultiplier
        self.utterance!.voice = self.voice!
        self.synthesizer?.stopSpeaking(at: .immediate)
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer?.delegate = self
        if onStart != nil { self.onStart = onStart }
        if onComplete != nil { self.onComplete = onComplete }
        self.synthesizer!.speak(self.utterance!)
    }
    
    func stopSpeaking(at boundary: AVSpeechBoundary = .immediate) {
        self.synthesizer?.stopSpeaking(at: boundary)
        self.resetHandler()
        isSpeaking = false
        print("Synthesizer stop forced")
    }
    
    func resetHandler() {
        self.onStart = nil
        self.onComplete = nil
    }
    
    func clear() {
        self.stopSpeaking()
        self.resetHandler()
    }
    
    private func getVoiceId() -> String {
        let language_id: String = Setting.shared.langauge_id
        var id: String = ""
        switch language_id {
        case "en-GB":
            id = "com.apple.ttsbundle.siri_Martha_en-GB_compact"
        case "en-US", "en":
            id = AVSpeechSynthesisVoiceIdentifierAlex
        case "zh-Hant-HK":
            id = "com.apple.ttsbundle.Sin-Ji-compact"
        case "zh-Hant-TW", "zh-Hant":
            id = "com.apple.ttsbundle.Mei-Jia-compact"
        case "zh-Hans-CN", "zh-Hans":
            id = "com.apple.ttsbundle.Ting-Ting-compact"
        default:
            id = AVSpeechSynthesisVoiceIdentifierAlex
        }
        return id
    }
}

extension T2SManager {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Synthesizer start")
        isSpeaking = true
        withAnimation {
            onStart?()
        }
        self.onStart = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Synthesizer stop onComplete")
        isSpeaking = false
        withAnimation {
            onComplete?()
        }
        self.onComplete = nil
    }
    
}
