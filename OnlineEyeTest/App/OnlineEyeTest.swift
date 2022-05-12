//
//  OnlineEyeTest.swift
//  SigninV2
//
//  Created by Гералд Бирген on 27.09.2020.
//

import SwiftUI

@main
struct OnlineEyeTest: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var appState = AppState()
    @ObservedObject var setting = Setting.shared
    @ObservedObject var user = User.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LaunchView(appState: appState)
                    .navigationBarHidden(true)
            }
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    setting.sync()
                } else {
                    if T2SManager.shared.isSpeaking {
                        T2SManager.shared.stopSpeaking()
                    }
                    SpeechRecognizerManager.shared.stopAll()
                }
            }
        }
    }
}




