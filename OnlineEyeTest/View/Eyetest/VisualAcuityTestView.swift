

import SwiftUI

struct VisualAcuityTestView: View {
    @ObservedObject var viewModel: VisualAcurityTestViewModel
    @State private var showAlert = false
    @State private var textInput: String = ""
    @Binding var currentTest: EyeTestType
    @ObservedObject var synthesizer = T2SManager.shared
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @Binding var isLoading: Bool
    @Binding var isTracking: Bool
    @Environment(\.displayScale) var displayScale: CGFloat
    @FocusState private var isFocused: Bool
    @State private var isHidingText: Bool = false
    
    private var isRightEye: Bool {
        viewModel.currentEye == .Right
    }
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        VStack{
            Spacer()
            ImageSet
                .cornerRadius(15)
                .onTapGesture {
                    isFocused = false
                }
            EyeHint(isRightEye: isRightEye)
            if !isHidingText {
                Text("Which4LettersDoYouSeeText")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom])
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            }
            VStack {
                HStack {
                    InputBox
                        .shadow(color: .blue.opacity(0.2), radius: 5, x: 0, y: 5)
                        .alert(isPresented: $showAlert){
                            Alert(
                                title:Text("InvalidInputText"),
                                message:Text("PleaseEnter4LettersText")
                            )
                        }
                    ButtonDone
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                if !isHidingText && isListening {
                    VStack {
                        Text("VIInputHint_Test3")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("VIKeywordHint_Test3")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .padding(.horizontal, 5)
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onChange(of: textInput) { newValue in
            textInput = textInput.uppercased()
        }
        .onChange(of: isRightEye) { newValue in
            if newValue == true {
                HapticManager.shared.notification(type: .warning)
            }
        }
        .onChange(of: isFocused) { newValue in
            withAnimation {
                isHidingText = isFocused
            }
            if newValue == true {
                synthesizer.stopSpeaking()
                speechRecognizer.stop(soundAndHapticEnabled: false)
            }
        }
        // *** VI logic ***
        .onAppear { // first VI
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                if !isLoading && isTracking {
                    if !isRightEye {
                        let vi: String = NSLocalizedString("VI_Left_Which4LettersDoYouSeeText", comment: "")
                        T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                    } else {
                        let vi: String = NSLocalizedString("VI_Right_Which4LettersDoYouSeeText", comment: "")
                        T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                    }
                }
            }
        }
        .onChange(of: isLoading) { newValue in // after re-calibration
            if newValue == false && isTracking {
                isFocused = false
                textInput = ""
                if !isRightEye {
                    let vi: String = NSLocalizedString("VI_Left_Which4LettersDoYouSeeText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                } else {
                    let vi: String = NSLocalizedString("VI_Right_Which4LettersDoYouSeeText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                }
            }
        }
        .onChange(of: isRightEye) { newValue in
            if newValue == true && !isLoading && isTracking && isFocused == false {
                let vi: String = NSLocalizedString("VI_Right_Which4LettersDoYouSeeText", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
            }
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in // process user response
            if newValue != "" {
                var temp = String(newValue.split(separator: " ").last ?? "")
                temp = temp == "" ? newValue : temp
                let result = temp.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains("confirm") { // english only
                    if textInput != "" {
                        HapticManager.shared.impact(style: .medium)
                        ButtonDoneSubmit()
                    }
                } else if result.contains("delete") {
                    if textInput.count > 0 {
                        textInput = String(textInput.dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                } else if result.contains("cancel") {
                    textInput = ""
                }  else { // update textInput
                    textInput += result[0]
                }
            }
        })
        .onDisappear {
            speechRecognizer.stop(soundAndHapticEnabled: false)
            synthesizer.stopSpeaking()
            print("VisualAcuityTestView 3 disappear")
        }
    }
}

extension VisualAcuityTestView {
    
    private func startListeningVI() {
        withAnimation {
            do {
                try speechRecognizer.start(isEnglish: true)
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
    
    private var InputBox: some View {
        TextField("Enter4LettersHereText", text: self.$textInput)
            .padding()
            .frame(maxHeight: 40)
            .keyboardType(.alphabet)
            .disableAutocorrection(true)
            .background(.bar)
            .cornerRadius(15)
            .focused($isFocused)
            .onSubmit {
                ButtonDoneSubmit()
            }
    }
    
    private var ButtonDone: some View {
        Button {
            HapticManager.shared.impact(style: .medium)
            synthesizer.stopSpeaking()
            speechRecognizer.stop(soundAndHapticEnabled: false)
            ButtonDoneSubmit()
        } label: {
            Text("ConfirmText")
                .fontWeight(.bold)
                .padding(10)
                .frame(maxHeight: 40)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(15)
        }
    }
    
    private func ButtonDoneSubmit() {
        let temp = viewModel.currentEye
        if(isInputValid(input: textInput)){
            if !isRightEye {
                let _ = viewModel.InputLeftEyeAnswer(inputanswer: self.textInput)
            } else {
                let _ = viewModel.InputRightEyeAnswer(inputanswer: self.textInput)
                viewModel.generateResult()
                speechRecognizer.stop()
                withAnimation {
                    self.currentTest = .AstigmatismTest_4
                }
            }
            self.textInput = ""
        } else {
            self.showAlert = true
            self.textInput = ""
        }
        let temp_final = viewModel.currentEye
        if temp != temp_final {
            speechRecognizer.stop(soundAndHapticEnabled: false)
        }
    }
    
    private var ImageSet: some View {
        HStack{
            if !isRightEye {
                LeftEyeImageSet
            } else {
                RightEyeImageSet
            }
        }
        .frame(width: 330, height: isFocused ? 250 : 330)
        .background(.white)
    }
    
    private var LeftEyeImageSet: some View {
        Group {
            Image(viewModel.image1)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale)
            Image(viewModel.image2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale)
            Image(viewModel.image3)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale)
            Image(viewModel.image4)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.leftEyeLevel])*displayScale)
        }
    }
    
    private var RightEyeImageSet: some View {
        Group {
            Image(viewModel.image1)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale)
            Image(viewModel.image2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale)
            Image(viewModel.image3)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale)
            Image(viewModel.image4)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale,height:CGFloat(VATwordSize[viewModel.rightEyeLevel])*displayScale)
        }
    }
    
    func isInputValid(input: String) -> Bool {
        if input.count != 4 {
            return false
        }
        let array = Array(input)
        let result = isAlphabet(c: array[0]) && isAlphabet(c: array[1]) && isAlphabet(c: array[2]) && isAlphabet(c: array[3])
        return result
    }
    
    func isAlphabet(c: String.Element) -> Bool {
        let alphabets: Set = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        for alphabet in alphabets {
            if c.uppercased() == alphabet {
                return true
            }
        }
        return false
    }
}

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}

struct VisualAcurityTestView_Previews: PreviewProvider {
    static var previews: some View {
        VisualAcuityTestView(viewModel: VisualAcurityTestViewModel(), currentTest: .constant(.VisualAcuityTest_3), speechRecognizer: SpeechRecognizer(), isLoading: .constant(false), isTracking: .constant(true))
    }
}
