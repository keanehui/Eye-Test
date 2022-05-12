//
//  SettingView.swift
//  OnlineEyeTest
//
import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var setting = Setting.shared
    
    var body: some View {
        Form {
            Section {} header: { Text("") } // placeholder
            Section {
                HStack {
                    Text("LanguageText")
                    Spacer()
                    Text(setting.langauge_id_description)
                        .foregroundColor(.gray)
                }
            } header: {
                Text("LocalisationText")
            }

            Section {
                HStack {
                    Text("HapticFeedbackText")
                    Spacer()
                    Text(setting.haptic_enabled_description)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("SoundEffectText")
                    Spacer()
                    Text(setting.sound_enabled_description)
                        .foregroundColor(.gray)
                }
            } header: {
                Text("FeedbackText")
            }
            
            Section {
                HStack {
                    Text("VoiceInstructionText")
                    Spacer()
                    Text(setting.VI_enabled_description)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("SpeedText")
                    Spacer()
                    Text(setting.VI_speed_description)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("PitchText")
                    Spacer()
                    Text(setting.VI_pitch_description)
                        .foregroundColor(.gray)
                }
            } header: {
                Text("VoiceInstructionText")
            }
            Section {
                Button {
                    openSetting()
                } label: {
                    Text("EditSettingsText")
                }
            } footer: {
                Text("SettingsFooter")
            }
        }
        .overlay(alignment: .top) {
            HStack(alignment: .center) {
                    Text("SettingsTitleText")
                        .bold()
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.ultraThinMaterial)
            .overlay(alignment: .trailing) {
                Button {
                    dismiss()
                } label: {
                    Text("DoneText")
                        .bold()
                        .padding()
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

func openSetting() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
