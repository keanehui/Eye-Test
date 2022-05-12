//
//  VolumeTooLow.swift
//  Calibration
//
//  Created by Keane Hui on 14/3/2022.
//

import SwiftUI

struct VolumeTooLow: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .circular)
                .fill(.clear)
                .background(Material.ultraThinMaterial)
            VStack(spacing: 0) {
                Image(systemName: "speaker.slash.fill")
                    .font(.system(size: 80, design: .rounded))
                    .padding(.top)
                Text(NSLocalizedString("volumeTooLowText", comment: ""))
                    .fontWeight(.bold)
                    .padding()
            }
            .foregroundColor(.gray)
        }
        .frame(width: 180, height: 180)
        .cornerRadius(15)
        .padding()
    }
}

struct VolumeTooLow_Previews: PreviewProvider {
    static var previews: some View {
        VolumeTooLow()
    }
}
