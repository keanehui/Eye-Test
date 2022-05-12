//
//  Waveform.swift
//  Calibration
//
//  Created by Keane Hui on 31/3/2022.
//

import SwiftUI

struct AudioWaveformWithMic: View {
    var onTapToStart: (() -> Void)?
    var onTapToStop: (() -> Void)?
    
    @State private var isSpeaking: Bool = false
    
    var body: some View {
        ZStack {
            if isSpeaking {
                AudioWaveform()
                    .transition(.move(edge: .bottom).animation(.easeInOut))
            }
            Image(systemName: "mic.fill")
                .foregroundColor(isSpeaking ? .red : .gray)
                .font(.system(size: 50, design: .rounded))
                .padding(10)
                .background(.thickMaterial, in: Circle())
                .onTapGesture {
                    if !isSpeaking {
                        onTapToStart?()
                        withAnimation {
                            isSpeaking = true
                        }
                    }
                    else if isSpeaking {
                        onTapToStop?()
                        withAnimation {
                            isSpeaking = false
                        }
                    }
                }
        }
    }
}

struct AudioWaveform: View {
    var amplify1: CGFloat?
    var amplify2: CGFloat?
    
    var body: some View {
        ZStack {
            Waveform(color: .cyan, amplify: amplify1 ?? 100)
            Waveform(color: .purple, amplify: amplify2 ?? 50)
                .reverse()
        }
        .opacity(0.7)
    }
}

struct Waveform: View {
    var color: Color
    var amplify: CGFloat = 70
    
    var body: some View {
        TimelineView(.animation) { timeLine in
            Canvas { context, size in
                let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                let angle = timeNow.remainder(dividingBy: 2)
                let offset = angle * size.width
                
                context.translateBy(x: offset, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                context.translateBy(x: size.width*2, y: 0)
                context.fill(getPath(size: size), with: .color(color))
            }
        }
    }
    
    private func getPath(size: CGSize) -> Path {
        return Path { path in
            let midHeight = size.height / 2
            let width = size.width
            path.move(to: CGPoint(x: 0, y: midHeight))
            path.addCurve(to: CGPoint(x: width, y: midHeight), control1: CGPoint(x: width*0.5, y: midHeight+amplify), control2: CGPoint(x: width*0.5, y: midHeight-amplify))
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }
    
    func reverse() -> some View {
        return self.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct Waveform_Previews: PreviewProvider {
    static var previews: some View {
        AudioWaveform()
    }
}
