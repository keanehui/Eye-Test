import SwiftUI

struct AstigmatismTestView: View {
   
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @State private var isRightEye: Bool = false
    @Binding var currentTest: EyeTestType
    @ObservedObject var synthesizer = T2SManager.shared
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @Binding var isLoading: Bool
    @Binding var isTracking: Bool
    
    var body: some View {
        VStack{
            Spacer()
            Image(viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 330)
                .cornerRadius(15)
            EyeHint(isRightEye: isRightEye)
            Text("DoAllStripesHaveTheSameShadeOfBlackText")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom])
            HStack(spacing: 50) {
                ButtonYes
                ButtonNo
            }
            Spacer()
        }
        .padding()
        .onChange(of: isRightEye) { newValue in
            if newValue == true {
                HapticManager.shared.notification(type: .warning)
            }
        }
        // *** VI logic ***
        .onAppear { // first VI
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                if !isLoading && isTracking {
                    if !isRightEye {
                        let vi: String = NSLocalizedString("VI_Left_DoAllStripesHaveTheSameShadeOfBlackText", comment: "")
                        T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                    } else {
                        let vi: String = NSLocalizedString("VI_Right_DoAllStripesHaveTheSameShadeOfBlackText", comment: "")
                        T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                    }
                }
            }
        }
        .onChange(of: isLoading) { newValue in // after re-calibration
            if newValue == false && isTracking {
                if !isRightEye {
                    let vi: String = NSLocalizedString("VI_Left_DoAllStripesHaveTheSameShadeOfBlackText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                } else {
                    let vi: String = NSLocalizedString("VI_Right_DoAllStripesHaveTheSameShadeOfBlackText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                }
            }
        }
        .onChange(of: isRightEye) { newValue in
            if newValue == true && !isLoading && isTracking {
                let vi: String = NSLocalizedString("VI_Right_DoAllStripesHaveTheSameShadeOfBlackText", comment: "")
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
            print("AstigmatismTestView 4 disappear")
        }
        
    }
}

extension AstigmatismTestView {
    
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
            synthesizer.stopSpeaking()
            speechRecognizer.stop(soundAndHapticEnabled: false)
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
        speechRecognizer.stop(soundAndHapticEnabled: false)
        if(!self.isRightEye){
            self.isRightEye = true
            viewModel.InputLeftEyeAnswer(inputanswer: true)
        } else {
            viewModel.generateResult()
            viewModel.InputRightEyeAnswer(inputanswer: true)
            withAnimation {
                self.currentTest = .VisionFieldTest_5
            }
        }
    }
    
    private var ButtonNo: some View {
        Button {
            synthesizer.stopSpeaking()
            speechRecognizer.stop(soundAndHapticEnabled: false)
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
        speechRecognizer.stop(soundAndHapticEnabled: false)
        if !self.isRightEye {
            self.isRightEye = true
            viewModel.InputLeftEyeAnswer(inputanswer: false)
        } else {
            viewModel.InputRightEyeAnswer(inputanswer: false)
            viewModel.generateResult()
            withAnimation {
                self.currentTest = .VisionFieldTest_5
            }
        }
    }
    
}

struct AstigmatismTestView_Previews: PreviewProvider {
    static var previews: some View {
        AstigmatismTestView(viewModel: AstigmatismTestViewModel(), currentTest: .constant(.AstigmatismTest_4), speechRecognizer: SpeechRecognizer(), isLoading: .constant(false), isTracking: .constant(true))
    }
}

