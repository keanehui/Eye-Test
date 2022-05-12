//
//  CalibrationInstructionView.swift
//  Calibration
//
//  Created by Keane Hui on 23/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationInstructionView: View {
    @Binding var distance: Int
    @State private var scaled: Bool = false
    @Namespace var namespace
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    private var isDeltaSmall: Bool {
        isDistanceDeltaSmall(distance)
    }
    
    var body: some View {
        VStack {
            instructionShortView
            instructionFullView
        }
        .frame(maxWidth: .infinity)
    }
    
    let opacityInTransition: AnyTransition = AnyTransition.asymmetric(insertion: .opacity.animation(.linear(duration: 0.3)), removal: .opacity.animation(.linear(duration: 0.0)))
    let scalingAnimation: Animation = Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)
    let scalingAnimationDelay: Int = 500
    
    private var instructionShortView: some View {
        Group {
            if (distanceStatus == .missing) {
                Text(NSLocalizedString("instructionShortMissing", comment: ""))
                    .makeInstructionShort()
                    .transition(opacityInTransition)
                    .onAppear {
                        scaled = false
                    }
            }
            if (distanceStatus == .tooClose) {
                Group {
                    if isDeltaSmall {
                        Text(NSLocalizedString("instructionShortTooClose2", comment: ""))
                            .makeInstructionShort()
                    } else {
                        Text(NSLocalizedString("instructionShortTooClose1", comment: ""))
                            .makeInstructionShort()
                            .scaleEffect(scaled ? 2 : 1)
                            .onAppear {
                                startScalingDelayed()
                            }
                    }
                }
                .transition(opacityInTransition)
            }
            if (distanceStatus == .valid) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 55, weight: .regular, design: .rounded))
                    .foregroundColor(.green)
                    .scaleEffect(scaled ? 1.2 : 1)
                    .transition(opacityInTransition)
                    .onAppear {
                        scaled = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(scalingAnimationDelay)) {
                            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                scaled.toggle()
                            }
                        }
                    }
            }
            if (distanceStatus == .tooFar) {
                Group {
                    if isDeltaSmall {
                        Text(NSLocalizedString("instructionShortTooFar2", comment: ""))
                            .makeInstructionShort()
                    } else {
                        Text(NSLocalizedString("instructionShortTooFar1", comment: ""))
                            .makeInstructionShort()
                            .scaleEffect(scaled ? 0.5 : 1)
                            .onAppear {
                                startScalingDelayed()
                            }
                    }
                }
                .transition(opacityInTransition)
            }
        }
        .foregroundColor(instructionThemeColor)
    }
    
    private var instructionFullView: some View {
        Group {
            if (distanceStatus == .missing) {
                (Text(NSLocalizedString("instructionFullMissing1", comment: "")) +
                 Text(NSLocalizedString("instructionFullMissing2", comment: "")).foregroundColor(.blue) +
                 Text(NSLocalizedString("instructionFullMissing3", comment: "")))
                    .makeInstructionFull()
                    .padding(.top)
            }
            if (distanceStatus == .tooClose) {
                Text(NSLocalizedString("instructionFullTooClose", comment: ""))
                    .makeInstructionFull()
                    .padding(.top)
            }
            if (distanceStatus == .valid) {
                Text(NSLocalizedString("instructionFullValid", comment: ""))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            if (distanceStatus == .tooFar) {
                Text(NSLocalizedString("instructionFullTooFar", comment: ""))
                    .makeInstructionFull()
                    .padding(.top)
            }
        }
        .foregroundColor(instructionThemeColor)
        .transition(opacityInTransition)
    }
    
    private func startScalingDelayed() {
        scaled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(scalingAnimationDelay)) {
            withAnimation(scalingAnimation) {
                scaled.toggle()
            }
        }
    }
}

extension CalibrationInstructionView {
    private var instructionThemeColor: Color {
        switch distanceStatus {
        case .missing:
            return .gray
        case .tooClose, .tooFar:
            return .orange
        case .valid:
            return .green
        }
    }
}

extension Text {
    func makeInstructionShort() -> some View {
        self.fontWeight(Font.Weight.bold)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
    }
    
    func makeInstructionFull() -> some View {
        self.fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

struct CalibrationInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationInstructionView(distance: .constant(40))
    }
}
