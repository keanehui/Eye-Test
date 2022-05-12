//
//  CalibrationPreIntro.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationPostIntro: View {
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var isGoingToTest: Bool = false
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "checkmark").padding(.leading).foregroundColor(.green)
                Image(systemName: "iphone").foregroundColor(.gray)
            }
            .font(.system(size: 70))
            Text(NSLocalizedString("postIntroTextTop", comment: ""))
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            NavigationLink(destination: EyeTestMainView(distance: $distance, isCalibrated: $isCalibrated, speechRecognizer: speechRecognizer, appState: appState), isActive: $isGoingToTest) {}.frame(width: 0, height: 0)
            Text(NSLocalizedString("postIntroTextBottom", comment: ""))
                .font(.title3)
                .multilineTextAlignment(.center)
            Button {
                T2SManager.shared.stopSpeaking()
                speechRecognizer.stop(soundAndHapticEnabled: false)
                isGoingToTest = true
            } label: {
                Text(NSLocalizedString("postIntroButtonTop", comment: ""))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(10)
            }
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            Button {
                T2SManager.shared.stopSpeaking()
                speechRecognizer.stop(soundAndHapticEnabled: false)
                isCalibrated = false
                dismiss()
            } label: {
                Text(NSLocalizedString("postIntroButtonBottom", comment: ""))
                    .padding([.top, .leading, .trailing])
            }
        }
        .onDisappear {
            T2SManager.shared.clear()
            speechRecognizer.reset()
        }
        .onAppear {
            let vi = NSLocalizedString("postIntroVI", comment: "")
            T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in
            if newValue != "" {
                var temp = String(newValue.split(separator: " ").last ?? "")
                temp = temp == "" ? newValue : temp
                let result = temp.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains(String(localized: "VI_Yes").lowercased()) {
                    stopListeningVI()
                    isGoingToTest = true
                } else if result.contains(String(localized: "VI_No").lowercased()) {
                    stopListeningVI()
                    isGoingToTest = false
                    dismiss()
                }
            }
        })
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


struct CalibrationPreIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPostIntro(distance: .constant(40), isCalibrated: .constant(false),  speechRecognizer: SpeechRecognizer(), appState: AppState())
    }
}
