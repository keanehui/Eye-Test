import SwiftUI

struct EyeTestMainView: View {
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @ObservedObject var synthesizer = T2SManager.shared
    @ObservedObject var appState: AppState
    
    @State private var currentTest: EyeTestType = .ColorBlindTest_1
    
    @StateObject var colourBlindTestViewModel: ColourBlindTestViewModel = ColourBlindTestViewModel()
    @StateObject var redDesatuationTestViewModel: RedDesatuationTestViewModel = RedDesatuationTestViewModel()
    @StateObject var visualAcurityTestViewModel: VisualAcurityTestViewModel = VisualAcurityTestViewModel()
    @StateObject var astigmatismTestViewModel: AstigmatismTestViewModel = AstigmatismTestViewModel()
    @StateObject var visionFieldTestViewModel: VisionFieldTestViewModel = VisionFieldTestViewModel()

    // *** distance tracking ***
    @State private var isLoading: Bool = false
    @State private var isTracking: Bool = false
    @State private var isPresentingCalibration: Bool = false
    @State private var isPresentingAlert: Bool = false
    // *** distance tracking ***
    
    // *** VI UI ***
    private var isSpeaking: Bool {
        synthesizer.isSpeaking
    }
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    // *** VI UI ***
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    var body: some View {
        VStack {
            Alerts
            switch(currentTest){
            case .ColorBlindTest_1:
                ColourBlindTestView(viewModel: colourBlindTestViewModel, currentTest: $currentTest, speechRecognizer: speechRecognizer, isLoading: $isLoading, isTracking: $isTracking)
                    .padding(.top)
                    .animation(.easeInOut, value: currentTest)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .onAppear { // disable auto lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
            case .RedDesatuationTest_2:
                RedDesatuationTestView(viewModel: redDesatuationTestViewModel, currentTest: $currentTest, speechRecognizer: speechRecognizer, isLoading: $isLoading, isTracking: $isTracking)
                    .padding(.top)
                    .animation(.easeInOut, value: currentTest)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .onAppear { // disable auto lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
            case .VisualAcuityTest_3:
                VisualAcuityTestView(viewModel: visualAcurityTestViewModel, currentTest: $currentTest, speechRecognizer: speechRecognizer, isLoading: $isLoading, isTracking: $isTracking)
                    .padding(.top)
                    .animation(.easeInOut, value: currentTest)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .onAppear { // disable auto lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
            case .AstigmatismTest_4:
                AstigmatismTestView(viewModel: astigmatismTestViewModel, currentTest: $currentTest, speechRecognizer: speechRecognizer, isLoading: $isLoading, isTracking: $isTracking)
                    .padding(.top)
                    .animation(.easeInOut, value: currentTest)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .onAppear { // disable auto lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
            case .VisionFieldTest_5:
                VisionFieldTestView(viewModel: visionFieldTestViewModel, currentTest: $currentTest, speechRecognizer: speechRecognizer, isLoading: $isLoading, isTracking: $isTracking, appState: appState)
                    .padding(.top)
                    .animation(.easeInOut, value: currentTest)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .onAppear { // disable auto lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    .onDisappear { // enable auto lock
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
            }
        }
        .onChange(of: currentTest) { newValue in
            HapticManager.shared.notification(type: .success)
        }
        // *** VI UI ***
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
        // *** Background distance tracking below ***
        .onAppear() {
            startTracking()
            print("Eye Test Main appear")
        }
        .overlay {
            if isLoading {
                LoadingView()
                    .onDisappear() {
                        if distanceStatus != .valid {
                            presentAlert()
                        }
                    }
            }
        }
        .overlay(alignment: .top) {
            if isTracking {
                VStack {
                    if !isLoading {
                        DistanceCapsule(distance: $distance)
                    }
                    CalibrationCameraView(distance: $distance)
                        .frame(width: 0, height: 0)
                        .opacity(0.0)
                        .onChange(of: distanceStatus) { newValue in
                            if !isLoading && newValue != .valid {
                                presentAlert()
                            }
                        }
                        .onAppear {
                            if isCalibrated == false {
                                presentAlert()
                            }
                        }
                }
                
            }
        }
        .sheet(isPresented: $isPresentingCalibration) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
                .onDisappear {
                    startTracking()
                }
        }
        .onChange(of: isPresentingCalibration) { newValue in
            if newValue == false {
                T2SManager.shared.stopSpeaking()
            }
        }
        
    }
}

extension EyeTestMainView {
    
    private var Alerts: some View {
        ZStack {
            Circle()
                .alert(
                    Text(NSLocalizedString("alertTitle", comment: "")), isPresented: $isPresentingAlert
                ) {
                    Button(role: .destructive) {
                        isCalibrated = false
                        synthesizer.stopSpeaking()
                        synthesizer.resetHandler()
                        speechRecognizer.stop(soundAndHapticEnabled: false)
                        DispatchQueue.main.async {
                            appState.rootViewId = UUID()
                        }
                    } label: {
                        Text(NSLocalizedString("alertButton1", comment: ""))
                    }
                    Button(role: .cancel) {
                        isPresentingCalibration = true
                        synthesizer.stopSpeaking()
                        speechRecognizer.stop(soundAndHapticEnabled: false)
                    } label: {
                        Text(NSLocalizedString("alertButton2", comment: ""))
                    }
                } message: {
                    Text(NSLocalizedString("alertText", comment: ""))
                }
        }
        .frame(width: 0, height: 0)
    }
    
    private func presentAlert() {
        print("alert status: \(distanceStatus)")
        isCalibrated = false
        isPresentingAlert = true
        isTracking = false
        T2SManager.shared.stopSpeaking()
        speechRecognizer.stop()
        SoundManager.shared.playSound(filename: "alert.mp3")
        HapticManager.shared.notification(type: .error)
    }
    
    private func startTracking() {
        isLoading = true
        isTracking = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            isLoading = false
        }
    }
    
}


enum EyeTestType: Int {
    case ColorBlindTest_1=1, RedDesatuationTest_2, VisualAcuityTest_3, AstigmatismTest_4, VisionFieldTest_5
    
    var name: String {
        switch self {
        case .ColorBlindTest_1:
            return "Colour Blind Test"
        case .RedDesatuationTest_2:
            return "Red Desatuation Test"
        case .VisualAcuityTest_3:
            return "Visual Acuity Test"
        case .AstigmatismTest_4:
            return "Astigmatism Test"
        case .VisionFieldTest_5:
            return "Vision Field Test"
        }
    }
}

struct EyeTestMainView_Previews: PreviewProvider {
    static var previews: some View {
        EyeTestMainView(distance: .constant(40), isCalibrated: .constant(true), speechRecognizer: SpeechRecognizer(), appState: AppState())
    }
}

