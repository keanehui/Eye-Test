//
//  HapticManager.swift
//  Calibration
//
//  Created by Keane Hui on 25/2/2022.
//

import Foundation
import UIKit
import SwiftUI

class HapticManager {
    static let shared = HapticManager()
    var enabled: Bool {
        Setting.shared.haptic_enabled
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        if !enabled {
            return
        }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if !enabled {
            return
        }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
