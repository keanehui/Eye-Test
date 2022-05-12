//
//  ContentView.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationIntroView: View {
    @ObservedObject var appState: AppState
    @State private var distance: Int = 0
    @State private var isCalibrated: Bool = false
    @State private var isPresenting: Bool = false
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @ObservedObject private var synthesizer = T2SManager.shared
    
    private var isSpeaking: Bool {
        synthesizer.isSpeaking
    }
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if (!isCalibrated) {
                CalibrationPreIntro(isPresenting: $isPresenting, speechRecognizer: speechRecognizer)
            } else {
                CalibrationCameraView(distance: $distance)
                    .frame(width: 0, height: 0)
                    .opacity(0.0)
                CalibrationPostIntro(distance: $distance, isCalibrated: $isCalibrated, speechRecognizer: speechRecognizer, appState: appState)
                    .overlay(alignment: .top) {
                        DistanceCapsule(distance: $distance)
                    }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .onDisappear {
            T2SManager.shared.clear()
            speechRecognizer.reset()
        }
        .onChange(of: isPresenting) { newValue in
            if newValue == false {
                T2SManager.shared.stopSpeaking()
            }
        }
        .sheet(isPresented: $isPresenting) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
        }
        .overlay(alignment: .topLeading) {
            if isSpeaking {
                SpeakerAnimation(size: 30)
                    .padding()
            }
        }
        .overlay(alignment: .topTrailing) {
            if isListening {
                MicAnimation(size: 30)
                    .padding()
            }
        }
        .overlay(alignment: .bottom) {
            if isListening {
                AudioWaveform(amplify1: 30, amplify2: 15)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .transition(.offset(x: 0, y: 80).combined(with: .opacity).animation(.easeInOut))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationIntroView(appState: AppState())
    }
}


