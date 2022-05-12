//
//  SpeechRecognizer.swift
//  Calibration
//
//  Created by Keane Hui on 28/3/2022.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject, Identifiable {
    var id: UUID
    
    var authorized: Bool
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    
    @Published var transcript: String
    @Published var isListening: Bool
    
    init() {
        self.id = UUID()
        self.isListening = false
        self.authorized = false
        self.transcript = ""
        SpeechRecognizerManager.shared.push(self)
    }
    
    deinit {
        reset()
        SpeechRecognizerManager.shared.pop(self)
    }
    
    func askPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
                case .authorized:
                    self.authorized = true
                    print("auth set true")
                default:
                    self.authorized = false
                    print("auth set false")
            }
        }
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true // perform transcription locally
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
//        try audioSession.overrideOutputAudioPort(.speaker)
        try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    func start(soundAndHapticEnabled: Bool = true, isEnglish: Bool? = false) throws {
        self.reset()
        do {
            let (new_audioEngine, new_request) = try Self.prepareEngine()
            self.audioEngine = new_audioEngine
            self.request = new_request
            if isEnglish != nil && isEnglish == true {
                self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
            } else {
                self.recognizer = SFSpeechRecognizer(locale: self.locale)
            }
            self.isListening = true
            if soundAndHapticEnabled {
                startSoundAndHaptic()
            }
            print("Recognizer start")
            self.task = self.recognizer!.recognitionTask(with: request!) { result, error in
//                let receivedFinalResult = result?.isFinal ?? false
//                let receivedError = error != nil
//                if receivedFinalResult || receivedError {
//                    self.audioEngine?.stop()
//                    self.audioEngine?.inputNode.removeTap(onBus: 0)
//                    if receivedError {
//                        print("Error when transcribing: \(error!.localizedDescription)")
//                    }
//                }
                if let result = result { // update result
                    self.transcript = ""
                    self.transcript = result.bestTranscription.formattedString
                    if let isEnglish = isEnglish, isEnglish == true {
                        print("transcript updated (en): \(self.transcript)")
                    } else {
                        print("transcript updated: \(self.transcript)")
                    }
                }
            }
        } catch {
            self.reset()
            print("Error in transcribing: \(error)")
        }
    }
    
    func getTranscript() -> String {
        print("return transcript: \(self.transcript)")
        return self.transcript
    }
    
    func stop(soundAndHapticEnabled: Bool = true) {
        self.isListening = false
        self.transcript = ""
        if soundAndHapticEnabled {
            stopSoundAndHaptic()
        }
        reset()
        print("Recognizer stop")
    }
    
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
        self.isListening = false
    }
    
    private func startSoundAndHaptic() {
        SoundManager.shared.playSound(filename: "beep.mp3")
        HapticManager.shared.impact(style: .medium)
    }
    
    private func stopSoundAndHaptic() {
        SoundManager.shared.playSound(filename: "double_click.mp3")
        HapticManager.shared.notification(type: .success)
    }
    
}

extension SpeechRecognizer {
    
    var locale: Locale {
        var id = ""
        switch Setting.shared.langauge_id {
        case "en-GB":
            id = "en-GB"
        case "en-US", "en":
            id = "en-US"
        case "zh-Hant-HK":
            id = "zh-HK"
        case "zh-Hant-TW", "zh-Hant":
            id = "zh-TW"
        case "zh-Hans-CN", "zh-Hans":
            id = "zh-CN"
        default:
            id = "en-US"
        }
        return Locale(identifier: id)
    }
    
}
