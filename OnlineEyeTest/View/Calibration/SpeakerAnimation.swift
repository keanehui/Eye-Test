//
//  SpeakerAnimation.swift
//  Calibration
//
//  Created by Keane Hui on 6/4/2022.
//

import SwiftUI

struct SpeakerAnimation: View {
    var size: CGFloat = 40.0
    
    var body: some View {
        TimelineView(.periodic(from: Date(), by: 0.5)) { timeline in
            let calendar = Calendar.current
            let second = calendar.component(.second, from: timeline.date)
            Group {
                if second % 2 == 0 {
                    Image(systemName: "speaker.wave.2.fill")
                } else {
                    Image(systemName: "speaker")
                }
            }
            .font(.system(size: size, weight: .medium, design: .rounded))
            .foregroundColor(.accentColor)
        }
    }
}

struct SpeakerAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerAnimation()
    }
}
