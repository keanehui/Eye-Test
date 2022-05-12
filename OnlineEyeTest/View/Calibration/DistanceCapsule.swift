//
//  DistanceCapsule.swift
//  Calibration
//
//  Created by Keane Hui on 3/3/2022.
//

import SwiftUI

struct DistanceCapsule: View {
    @Binding var distance: Int
    
    private var distanceColor: Color {
        getDistanceColor(distance)
    }
    
    var body: some View {
        let text: String = NSLocalizedString("distanceCapsuleText", comment: "")
        Text(text + ": \(distance)")
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(8)
            .background(distanceColor, in: Capsule())
            .padding()
            .animation(.linear, value: distanceColor)
    }
}

struct DistanceCapsule_Previews: PreviewProvider {
    static var previews: some View {
        DistanceCapsule(distance: .constant(40))
    }
}
