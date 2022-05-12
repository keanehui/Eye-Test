//
//  ColourFieldTestView.swift
//
//  Created by FYP on 23/1/2022.

import SwiftUI

struct VisionFieldTestView: View {
    @ObservedObject var viewModel: VisionFieldTestViewModel
    @State private var isRightEye: Bool = false
    @State private var isCompleted: Bool = false
    @Binding var currentTest: EyeTestType
    @ObservedObject var synthesizer = T2SManager.shared
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @Binding var isLoading: Bool
    @Binding var isTracking: Bool
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack{
            Spacer()
            Image(viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 330,height: 330)
                .cornerRadius(15)
            EyeHint(isRightEye: isRightEye)
            Text("AreAllTheSquaresEquallySpaced")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom])
            HStack(spacing: 50) {
                ButtonYes
                ButtonNo
            }
            Spacer()
            NavigationLink(destination: ResultListView(appState: appState), isActive: self.$isCompleted) {}
        }
        .padding()
        .onChange(of: isRightEye) { newValue in
            HapticManager.shared.notification(type: .warning)
        }
        // *** VI logic ***
        .onAppear { // first VI
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                if !isLoading && isTracking {
                    if !isRightEye {
                        let vi: String = NSLocalizedString("VI_Left_AreAllTheSquaresEquallySpaced", comment: "")
                        T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                    } else {
                        let vi: String = NSLocalizedString("VI_Right_AreAllTheSquaresEquallySpaced", comment: "")
                        T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                    }
                }
            }
        }
        .onChange(of: isLoading) { newValue in // after re-calibration
            if newValue == false && isTracking {
                if !isRightEye {
                    let vi: String = NSLocalizedString("VI_Left_AreAllTheSquaresEquallySpaced", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                } else {
                    let vi: String = NSLocalizedString("VI_Right_AreAllTheSquaresEquallySpaced", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                }
            }
        }
        .onChange(of: isRightEye) { newValue in
            if newValue == true && !isLoading && isTracking {
                let vi: String = NSLocalizedString("VI_Right_AreAllTheSquaresEquallySpaced", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
            }
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in // process user response
            if newValue != "" {
                var temp = String(newValue.split(separator: " ").last ?? "")
                temp = temp == "" ? newValue : temp
                let result = temp.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains(String(localized: "YesText").lowercased()) {
                    speechRecognizer.stop()
                    buttonYesAction()
                } else if result.contains(String(localized: "NoText").lowercased()) {
                    speechRecognizer.stop()
                    buttonNoAction()
                }
            }
        })
        .onDisappear {
            speechRecognizer.stop(soundAndHapticEnabled: false)
            synthesizer.stopSpeaking()
            print("VisionFieldTestView 5 disappear")
        }
    }
}

extension VisionFieldTestView {
    
    private func startListeningVI() {
        withAnimation {
            do {
                try speechRecognizer.start()
            } catch {
                speechRecognizer.reset()
                print("Error in startListeningVI: \(error.localizedDescription)")
            }
        }
    }
    
    private func stopListeningVI() {
        withAnimation {
            speechRecognizer.stop()
        }
    }
    
    private var ButtonYes: some View {
        Button {
            buttonYesAction()
        } label: {
            Text("YesText")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(50)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
    
    private func buttonYesAction() {
        HapticManager.shared.impact(style: .rigid)
        if !isRightEye {
            self.isRightEye = true
            speechRecognizer.stop(soundAndHapticEnabled: false)
            viewModel.InputLeftEyeAnswer(inputanswer: true)
        } else {
            viewModel.InputRightEyeAnswer(inputanswer: true)
            viewModel.generateResult()
            self.isCompleted = true
        }
    }
    
    private var ButtonNo: some View {
        Button {
            buttonNoAction()
        } label: {
            Text("NoText")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(50)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
    
    private func buttonNoAction() {
        HapticManager.shared.impact(style: .rigid)
        if !isRightEye {
            self.isRightEye = true
            speechRecognizer.stop(soundAndHapticEnabled: false)
            viewModel.InputLeftEyeAnswer(inputanswer: false)
        } else {
            viewModel.InputRightEyeAnswer(inputanswer: false)
            viewModel.generateResult()
            self.isCompleted = true
        }
    }
    
}

struct VisionFieldTestView_Previews: PreviewProvider {
    static var previews: some View {
        VisionFieldTestView(viewModel: VisionFieldTestViewModel(), currentTest: .constant(.VisionFieldTest_5), speechRecognizer: SpeechRecognizer(), isLoading: .constant(false), isTracking: .constant(true), appState: AppState())
    }
}
