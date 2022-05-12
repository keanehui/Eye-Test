//
//  Setting.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 17/4/2022.
//

import Foundation

class Setting: ObservableObject {
    static let shared = Setting()
    
    @Published private(set) var haptic_enabled: Bool
    @Published private(set) var sound_enabled: Bool
    @Published private(set) var VI_enabled: Bool
    @Published private(set) var VI_speed: Float
    @Published private(set) var VI_pitch: Float
    @Published private(set) var langauge_id: String
    
    init() {
        let userDefaults = UserDefaults.standard
        userDefaults.register(
            defaults: ["user_haptic_enabled": true,
                       "user_sound_enabled": true,
                       "user_voice_instruction_enabled": false,
                       "user_voice_instruction_rate": 0.5,
                       "user_voice_instruction_pitch": 1.0])
        
        self.haptic_enabled = userDefaults.bool(forKey: "user_haptic_enabled")
        self.sound_enabled = userDefaults.bool(forKey: "user_sound_enabled")
        self.VI_enabled = userDefaults.bool(forKey: "user_voice_instruction_enabled")
        self.VI_speed = userDefaults.float(forKey: "user_voice_instruction_rate")
        self.VI_pitch = userDefaults.float(forKey: "user_voice_instruction_pitch")
        self.langauge_id = Bundle.main.preferredLocalizations.first ?? "en-US"
        print("setting init: \(self.haptic_enabled) \(self.sound_enabled) \(self.VI_enabled) \(self.VI_speed) \(self.VI_pitch) \(Bundle.main.preferredLocalizations.first!)")
    }
    
    func sync() {
        let userDefaults = UserDefaults.standard
        self.haptic_enabled = userDefaults.bool(forKey: "user_haptic_enabled")
        self.sound_enabled = userDefaults.bool(forKey: "user_sound_enabled")
        self.VI_enabled = userDefaults.bool(forKey: "user_voice_instruction_enabled")
        self.VI_speed = userDefaults.float(forKey: "user_voice_instruction_rate")
        self.VI_pitch = userDefaults.float(forKey: "user_voice_instruction_pitch")
        self.langauge_id = Bundle.main.preferredLocalizations.first ?? "en-US"
        print("setting synced: \(self.haptic_enabled) \(self.sound_enabled) \(self.VI_enabled) \(self.VI_speed) \(self.VI_pitch) \(Bundle.main.preferredLocalizations.first!)")
    }
    
}

extension Setting {
    
    var haptic_enabled_description: String {
        if haptic_enabled {
            return "Enabled"
        } else {
            return "Disabled"
        }
    }
    
    var sound_enabled_description: String {
        if sound_enabled {
            return "Enabled"
        } else {
            return "Disabled"
        }
    }
    
    var VI_enabled_description: String {
        if VI_enabled {
            return "Enabled"
        } else {
            return "Disbaled"
        }
    }
    
    var VI_speed_description: String {
        switch VI_speed {
        case 0.6:
            return "Fast"
        case 0.5:
            return "Default"
        case 0.25:
            return "Slow"
        default:
            return "Unknown"
        }
    }
    
    var VI_pitch_description: String {
        switch VI_pitch {
        case 1.3:
            return "High"
        case 1.0:
            return "Default"
        case 0.8:
            return "Low"
        default:
            return "Unknown"
        }
    }
    
    var langauge_id_description: String {
        switch self.langauge_id {
        case "en-GB":
            return "English (UK)"
        case "en-US", "en":
            return "English (US)"
        case "zh-Hant-HK":
            return "Traditional Chinese (Hong Kong)"
        case "zh-Hant-TW", "zh-Hant":
            return "Traditional Chinese (Taiwan)"
        case "zh-Hans-CN", "zh-Hans":
            return "Simplified Chinese (China)"
        default:
            return "Unknown"
        }
    }
    
    
}

