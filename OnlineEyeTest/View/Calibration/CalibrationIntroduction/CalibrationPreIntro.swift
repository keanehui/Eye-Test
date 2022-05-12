//
//  CalibrationPostIntro.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationPreIntro: View {
    @Binding var isPresenting: Bool
    
    @State private var isShowingVolumeMessage: Bool = false
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    @Environment(\.dismiss) var dismiss
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "arrow.left.and.right").padding(.leading).foregroundColor(.orange)
                Image(systemName: "iphone").foregroundColor(.gray)
            }
            .font(.system(size: 70))
            Text(NSLocalizedString("preIntroTextTop", comment: ""))
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            Text(NSLocalizedString("preIntroTextBottom", comment: ""))
                .font(.title3)
            Button {
                T2SManager.shared.stopSpeaking()
                speechRecognizer.stop(soundAndHapticEnabled: false)
                isPresenting = true
            } label: {
                Text(NSLocalizedString("preIntroButtonTop", comment: ""))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
            }
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            Button(action: {
                T2SManager.shared.stopSpeaking()
                speechRecognizer.stop(soundAndHapticEnabled: false)
                dismiss()
            }) {
                Text(NSLocalizedString("preIntroButtonBottom", comment: ""))
                    .padding([.top, .leading, .trailing])
            }
        }
        .overlay(alignment: .center) {
            if isShowingVolumeMessage {
                VolumeTooLow()
                    .offset(x: 0.0, y: -50.0)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            }
        }
        .onAppear {
            if !isPresenting {
                checkVolume()
                let vi: String = NSLocalizedString("preIntroVI", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
            }
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in
            if newValue != "" {
                var temp = String(newValue.split(separator: " ").last ?? "")
                temp = temp == "" ? newValue : temp
                let result = temp.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains(String(localized: "VI_Yes").lowercased()) {
                    stopListeningVI()
                    isPresenting = true
                } else if result.contains(String(localized: "VI_No").lowercased()) {
                    stopListeningVI()
                    isPresenting = false
                    dismiss()
                }
            }
        })
    }
    
    private func checkVolume() {
        let vol = AVAudioSession.sharedInstance().outputVolume
        if T2SManager.shared.enabled && vol == 0.0 {
            HapticManager.shared.notification(type: .warning)
            isShowingVolumeMessage = true
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
                    isShowingVolumeMessage = false
                }
            }
        }
    }
    
    private func startListeningVI() {
        withAnimation {
            do {
                try speechRecognizer.start()
            } catch {
                speechRecognizer.reset()
                print("Error in startListeningVI: \(error)")
            }
            
        }
    }
    
    private func stopListeningVI() {
        withAnimation {
            speechRecognizer.stop()
        }
    }
}


struct CalibrationPostIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPreIntro(isPresenting: .constant(false), speechRecognizer: SpeechRecognizer())
    }
}
