//
//  LaunchView.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 20/4/2022.
//

import SwiftUI

struct LaunchView: View {
    @State private var distance: Int = 0
    @State private var isCalibrated: Bool = false
    @State private var pageControl: LaunchViewPageControl = .LoginView
    @ObservedObject var user = User.shared
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack {
            if pageControl == .LoginView {
                LoginView(pageControl: $pageControl)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).animation(.easeInOut))
            } else if pageControl == .MenuView {
                MenuView(pageControl: $pageControl, appState: appState)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).animation(.easeInOut))
            }
        }
        .id(appState.rootViewId)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: user.isLogin) { newValue in
            withAnimation {
                if newValue == true {
                    pageControl = .MenuView
                } else {
                    pageControl = .LoginView
                }
            }
        }
    }
}

enum LaunchViewPageControl: Int {
    case LoginView=1, MenuView
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(appState: AppState())
    }
}
