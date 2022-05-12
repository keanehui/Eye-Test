//
//  MicAnimation.swift
//  Calibration
//
//  Created by Keane Hui on 6/4/2022.
//

import SwiftUI

struct MicAnimation: View {
    var size: CGFloat = 40.0
    
    var body: some View {
        TimelineView(.periodic(from: Date(), by: 0.5)) { timeline in
            let calendar = Calendar.current
            let second = calendar.component(.second, from: timeline.date)
            Group {
                if second % 2 == 0 {
                    Image(systemName: "mic.fill")
                } else {
                    Image(systemName: "mic")
                }
            }
            .font(.system(size: size, weight: .medium, design: .rounded))
            .foregroundColor(.red)
        }
    }
}

struct MicAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MicAnimation()
    }
}
