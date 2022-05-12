import SwiftUI

struct ColourBlindTestView: View {
    @ObservedObject var viewModel: ColourBlindTestViewModel
    @Binding var currentTest: EyeTestType
    @ObservedObject var synthesizer = T2SManager.shared
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @Binding var isLoading: Bool
    @Binding var isTracking: Bool
    @State private var textInput: String = ""
    @State private var isRightEye: Bool = false
    @State private var isPresentingAlert = false
    @FocusState private var isFocused: Bool
    @State private var isHidingText: Bool = false
    
    @ObservedObject var user = User.shared
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        VStack{
            Spacer()
            Image(viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 330, height: 330)
                .cornerRadius(15)
                .onTapGesture {
                    isFocused = false
                }
            EyeHint(isRightEye: isRightEye)
            if !isHidingText {
                Text("WhatNumberDoYouSeeText")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom])
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                    .onTapGesture {
                        isFocused = false
                    }
            }
            VStack {
                HStack {
                    InputBox
                    ButtonDone
                        .alert(isPresented: $isPresentingAlert){
                            Alert(
                                title:Text("InvalidInputText"),
                                message:Text("PleaseEnterAPositiveNumberText")
                            )
                        }
                }
                if !isHidingText && isListening {
                    VStack {
                        Text("VIKeywordHint_Test1")
                            .frame(maxWidth: .infinity, alignment: .leading)
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
        .padding()
        .navigationBarHidden(true)
        .onChange(of: isRightEye) { newValue in
            HapticManager.shared.notification(type: .warning)
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
        .onChange(of: isTracking) { newValue in
            if newValue == true {
                textInput = ""
                isFocused = false
            }
        }
        // *** VI logic ***
        .onChange(of: isLoading) { newValue in
            if newValue == false && isTracking && textInput == "" {
                isFocused = false
                if !isRightEye {
                    let vi: String = NSLocalizedString("VI_Left_WhatNumberDoYouSeeText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                } else {
                    let vi: String = NSLocalizedString("VI_Right_WhatNumberDoYouSeeText", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
                }
            }
            textInput = ""
        }
        .onChange(of: isRightEye) { newValue in
            if newValue == true && !isLoading && isTracking && isFocused == false {
                let vi: String = NSLocalizedString("VI_Right_WhatNumberDoYouSeeText", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.5, onComplete: startListeningVI)
            }
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in
            if newValue != "" {
                var temp = String(newValue.split(separator: " ").last ?? "")
                temp = temp == "" ? newValue : temp
                let result = temp.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains(String(localized: "VI_Confirm").lowercased()) {
                    if textInput != "" {
                        ButtonDoneSubmit()
                    }
                } else if result.contains(String(localized: "VI_Delete").lowercased()) {
                    textInput = ""
                } else if result.contains(String(localized: "calibrationButtonCancel").lowercased()) {
                    textInput = ""
                } else { // update textInput
                    isNumberWithValue(String(result)) { result, value_str, value in
                        if result == true {
                            textInput = value_str
                        }
                    }
                }
            }
        })
        .onDisappear {
            synthesizer.stopSpeaking()
            speechRecognizer.stop(soundAndHapticEnabled: false)
            print("ColourBlindTestView 1 disappear")
        }
    }
}

extension ColourBlindTestView {
    
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
    
    private var InputBox: some View {
        VStack {
            TextField("EnterANumberHereText", text: $textInput)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
                .focused($isFocused)
                .background(.bar)
                .cornerRadius(15)
                .shadow(color: .blue.opacity(0.2), radius: 5, x: 0, y: 5)
                .onSubmit {
                    ButtonDoneSubmit()
            }
        }
    }
    
    private var ButtonDone: some View {
        Button {
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
        print("user input: \(textInput)")
        HapticManager.shared.impact(style: .rigid)
        if (isPositiveNumberOnly(textInput)){
            if (!isRightEye) {
                viewModel.InputLeftEyeAnswer(inputanswer: Int(textInput)!)
            } else {
                viewModel.InputRightEyeAnswer(inputanswer: Int(textInput)!)
            }

            if(viewModel.leftEyefinsihedTest>2){
                withAnimation {
                    if !isRightEye {
                        synthesizer.stopSpeaking()
                        speechRecognizer.stop()
                    }
                    self.isRightEye = true
                }
            }
            if(viewModel.rightEyefinsihedTest>2){
                viewModel.generateResult()
                synthesizer.stopSpeaking()
                speechRecognizer.stop()
                withAnimation {
                    self.currentTest = .RedDesatuationTest_2
                }
            }
        } else {
            print("input is invalid: \(textInput)")
            self.isPresentingAlert = true
        }
        textInput = ""
    }
    
}

struct EyeHint: View {
    @Environment(\.colorScheme) var colorScheme
    
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var isRightEye: Bool
    
    var accentColor: Color = Color.teal
    
    var body: some View {
        HStack(spacing: 30) {
            Group {
                if !isRightEye {
                    EyeHintLeftText
                } else {
                    EyeHintRightText
                }
                HStack(spacing: 20) {
                    if !isRightEye {
                        EyeOpen
                        EyeClose
                    } else {
                        EyeClose
                        EyeOpen
                    }
                    
                }
                .padding(5)
                .background(.ultraThickMaterial)
                .cornerRadius(15)
                .shadow(color: isDarkMode ? .teal.opacity(0.15) : .black.opacity(0.15), radius: 5, x: 0, y: 3)
            }
            .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.5)), removal: .opacity.animation(.easeInOut(duration: 0.0))))
        }
        .font(.system(size: 30, weight: .bold, design: .rounded))
        .padding(.top)
    }
    
    private var EyeHintLeftText: some View {
        Text("EyeHintUseText")
            .bold()
            .font(.system(size: 20)) +
        Text("EyeHintLeftText")
            .bold()
            .font(.system(size: 20))
            .foregroundColor(accentColor) +
        Text("EyeHintOnlyText")
            .bold()
            .font(.system(size: 20))
    }
    
    private var EyeHintRightText: some View {
        Text("EyeHintUseText")
            .bold()
            .font(.system(size: 20)) +
        Text("EyeHintRightText")
            .bold()
            .font(.system(size: 20))
            .foregroundColor(accentColor) +
        Text("EyeHintOnlyText")
            .bold()
            .font(.system(size: 20))
    }
    
    private var EyeOpen: some View {
        Image(systemName: "eye.fill")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(accentColor)
    }
    
    private var EyeClose: some View {
        Image(systemName: "minus")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.gray)
    }
}

extension ColourBlindTestView {
    
    func isPositiveNumberOnly(_ str: String) -> Bool {
        let cleaned_str = str.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let temp = Int(cleaned_str) ?? Int.min
        return (temp >= 0)
    }
    
    func isNumberWithValue(_ str: String, onComplete: @escaping ((_ result: Bool, _ value_str: String, _ value: Int) -> ())) {
        let number_map = ["zero": 0, "one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10, "to": 2, "for": 4, "sex": 6, "ate": 8, "一": 1, "二": 2, "三": 3, "四": 4, "五": 5, "六": 6, "七": 7, "八": 8, "九": 9, "十": 10]
        let cleaned_str = str.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        for (num_word, num_int) in number_map {
            if cleaned_str == num_word {
                onComplete(true, String(num_int).trimmingCharacters(in: .whitespacesAndNewlines), num_int)
                return
            }
        }
        let temp = Int(cleaned_str) ?? Int.min
        if temp >= 0 {
            onComplete(true, String(temp).trimmingCharacters(in: .whitespacesAndNewlines), temp)
            return
        } else {
            onComplete(false, "", Int.min)
        }
    }
    
}

struct ColourBlindTestView_Previews: PreviewProvider {
    static var previews: some View {
        ColourBlindTestView(viewModel: ColourBlindTestViewModel(), currentTest: .constant(.ColorBlindTest_1), speechRecognizer: SpeechRecognizer(), isLoading: .constant(false), isTracking: .constant(true))
    }
}

