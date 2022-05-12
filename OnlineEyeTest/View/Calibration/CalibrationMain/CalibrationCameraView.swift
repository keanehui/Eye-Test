//
//  CalibrationCameraView.swift
//  Calibration
//
//  Created by Keane Hui on 23/2/2022.
//

import SwiftUI

struct CalibrationCameraView: View {
    @Binding var distance: Int
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    private var distanceColor: Color {
        getDistanceColor(distance)
    }
    
    var body: some View {
        ZStack {
            ARKitViewControllerRepresentable(distance: $distance)
            Image(systemName: "square.dashed")
                .foregroundColor(distanceColor)
                .font(
                    .system(size: UIScreen.main.bounds.width*0.7,
                            weight: getDistanceStatus(distance) == .missing ? .ultraLight : .light))
                .animation(.easeInOut, value: distanceColor)
            Image(systemName: "face.smiling.fill")
                .foregroundColor(.blue)
                .font(.system(size: 150, weight: .ultraLight))
                .opacity(distanceStatus == .missing ? 0.9 : 0.0)
                .animation(.easeInOut, value: distanceStatus)
        }
        .frame(height: UIScreen.main.bounds.height*0.45)
        .cornerRadius(20)
    }
}

struct CalibrationCameraView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationCameraView(distance: .constant(40))
    }
}
