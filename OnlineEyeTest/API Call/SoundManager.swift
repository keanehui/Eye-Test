//
//  SoundManager.swift
//  Calibration
//
//  Created by Keane Hui on 27/2/2022.
//

import Foundation
import AVKit
import SwiftUI

class SoundManager {
    static let shared = SoundManager()
    var player: AVAudioPlayer?
    var enabled: Bool {
        Setting.shared.sound_enabled
    }
    
    func playSound(filename: String) {
        if !enabled {
            return
        }
        let filenameArr: [String] = filename.components(separatedBy: ".")
        guard let url = Bundle.main.url(forResource: filenameArr[0], withExtension: filenameArr[1]) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("played: \(filename)")
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

