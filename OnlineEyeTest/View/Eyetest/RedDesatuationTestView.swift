import SwiftUI

struct RedDesatuationTestView: View {
    @ObservedObject var viewModel: RedDesatuationTestViewModel
    @State private var isRightEye: Bool = false
    @State private var isTimerStarted: Bool = false
    @State private var secondsSinceStart: CGFloat = 0.0
    @Binding var currentTest: EyeTestType
    @ObservedObject var synthesizer = T2SManager.shared
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @Binding var isLoading: Bool
    @Binding var isTracking: Bool
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var timeRemaining: Int {
        Int(5.0 - secondsSinceStart)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 330, height: 330)
                .cornerRadius(15)
            if !isRightEye {

                EyeHint(isRightEye: isRightEye)
                Text("LookAtBlackDotFor5SecondsText")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom])
                    .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.5)), removal: .opacity.animation(.easeInOut(duration: 0.0))))
            } else {
                EyeHint(isRightEye: isRightEye)
                Text("IsTheImageDimmerText")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom])
                    .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.5)), removal: .opacity.animation(.easeInOut(duration: 0.0))))
            }
            if !isRightEye {
                ButtonStart
                    .opacity(isTimerStarted ? 0.0 : 1.0)
                    .overlay(alignment: .center) {
                        Text("\(timeRemaining)")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .opacity(isTimerStarted ? 1.0 : 0.0)
                    }
            } else {
                HStack(spacing: 50) {
                    ButtonYes
                    ButtonNo
                }
                .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.5)), removal: .opacity.animation(.easeInOut(duration: 0.0))))
            }
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            secondsSinceStart = 0.0
            isTimerStarted = false
        }
        .onReceive(timer) { _ in
            if isTimerStarted {
                if secondsSinceStart < 5 {
                    HapticManager.shared.impact(style: .rigid)
                    secondsSinceStart += 1
                } else {
                    isRightEye = true
                    isTimerStarted = false
                    HapticManager.shared.notification(type: .warning)
                }
            }
        }
        // *** VI logic ***
        .onAppear { // first VI
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                if !isLoading && isTracking && !isRightEye {
                    let vi: String = NSLocalizedString("VI_Left_LookAtBlackDotFor5SecondsText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                }
            }
        }
        .onChange(of: isLoading) { newValue in // after re-calibration
            if newValue == false && isTracking {
                if !isRightEye {
                    let vi: String = NSLocalizedString("VI_Left_LookAtBlackDotFor5SecondsText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                } else {
                    let vi: String = NSLocalizedString("IsTheImageDimmerText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                }
            }
        }
        .onChange(of: isRightEye) { newValue in
            if newValue == true {
                let vi: String = NSLocalizedString("IsTheImageDimmerText", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
            }
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in // process user response
            if newValue != "" {
                var temp = String(newValue.split(separator: " ").last ?? "")
                temp = temp == "" ? newValue : temp
                let result = temp.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if !isRightEye { // left eye
                    if result.contains(String(localized: "StartButtonText").lowercased()) {
                        HapticManager.shared.impact(style: .medium)
                        restartTimer()
                        withAnimation {
                            speechRecognizer.stop()
                        }
                    }
                } else { // right eye
                    if result.contains(String(localized: "YesText").lowercased()) {
                        speechRecognizer.stop()
                        buttonYesAction()
                    } else if result.contains(String(localized: "NoText").lowercased()) {
                        speechRecognizer.stop()
                        buttonNoAction()
                    }
                }
            }
        })
        .onDisappear {
            speechRecognizer.stop(soundAndHapticEnabled: false)
            synthesizer.stopSpeaking()
            print("RedDesatuationTestView 2 disappear")
        }
    }
}

extension RedDesatuationTestView {
    
    private func restartTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        isTimerStarted = true
    }
    
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

    private var ButtonStart: some View {
        Button {
            HapticManager.shared.impact(style: .medium)
            restartTimer()
            synthesizer.stopSpeaking()
            speechRecognizer.stop(soundAndHapticEnabled: false)
        } label: {
            Text("StartButtonText")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.5)), removal: .opacity.animation(.easeInOut(duration: 0.0))))
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
        HapticManager.shared.impact(style: .medium)
        synthesizer.stopSpeaking()
        speechRecognizer.stop(soundAndHapticEnabled: false)
        viewModel.InputAnswer(inputanswer: true)
        viewModel.generateResult()
        withAnimation {
            self.currentTest = .VisualAcuityTest_3
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
        HapticManager.shared.impact(style: .medium)
        synthesizer.stopSpeaking()
        speechRecognizer.stop(soundAndHapticEnabled: false)
        viewModel.InputAnswer(inputanswer: false)
        viewModel.generateResult()
        withAnimation {
            self.currentTest = .VisualAcuityTest_3
        }
    }
    
}

struct RedDesatuationTestView_Previews: PreviewProvider {
    static var previews: some View {
        RedDesatuationTestView(viewModel: RedDesatuationTestViewModel(), currentTest: .constant(.RedDesatuationTest_2), speechRecognizer: SpeechRecognizer(), isLoading: .constant(false), isTracking: .constant(true))
    }
}

