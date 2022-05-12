//
//  LoadingView.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 14/4/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.regularMaterial)
                ProgressView()
            }
            .frame(width: 150, height: 150)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
