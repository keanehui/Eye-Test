//
//  ResultView.swift
//  OnlineEyeTest
//
//  Created by FYP on 6/2/2022.
//

import SwiftUI

struct ViewResultView: View {
    
    @State var visualAcuityTestLeftEyeTuple: [(date: String, value: Double)] = []
    @State var visualAcuityTestRightEyeTuple: [(date: String, value: Double)] = []
    
    @State var astigmatismTestLeftEyeTuple: [(date: String, value: Double)] = []
    @State var astigmatismTestRightEyeTuple: [(date: String, value: Double)] = []
    
    @State var visionFieldTestLeftEyeTuple: [(date: String, value: Double)] = []
    @State var visionFieldTestRightEyeTuple: [(date: String, value: Double)] = []
    
    @State var colorVisionTestLeftEyeTuple: [(date: String, value: String)] = []
    @State var colorVisionTestRightEyeTuple: [(date: String, value: String)] = []
    
    @State var colorVisionTestRedGreenColorBlindnessLeftEyeTuple: [(date: String, value: Double)] = []
    @State var colorVisionTestRedGreenColorBlindnessRightEyeTuple: [(date: String, value: Double)] = []
    
    @State var colorVisionTestRedBlackColorBlindnessLeftEyeTuple: [(date: String, value: Double)] = []
    @State var colorVisionTestRedBlackColorBlindnessRightEyeTuple: [(date: String, value: Double)] = []
    
    @State var colorVisionTestRedSensitivityLeftEyeTuple: [(date: String, value: Double)] = []
    @State var colorVisionTestRedSensitivityRightEyeTuple: [(date: String, value: Double)] = []
    
    @State var eyeTestCount: Int = 0
    
    @State var focusedGraph: ViewResultGraphType = .Visual_Acuity_Test_1
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var user = User.shared
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if (self.eyeTestCount == 0) {
                    Text("NoResultToViewText")
                        .padding()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                } else if (self.eyeTestCount == 1) {
                    Text("YouCompleted1EyeTestText")
                        .padding()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Text("\(visualAcuityTestLeftEyeTuple[0].date)")
                        .font(.system(size: 24))
                    Divider()
                    Group{
                        Text("Snellen ratio (Left eye): ")
                        Text("\(visualAcuityTestLeftEyeTuple[0].value)")
                        Text("Snellen ratio (Right eye): ")
                        Text("\(visualAcuityTestRightEyeTuple[0].value)")
                        Text("Astigmatism test status (Left eye): ")
                        Text("\(astigmatismTestLeftEyeTuple[0].value)")
                        Text("Astigmatism test status (Right eye): ")
                        Text("\(astigmatismTestRightEyeTuple[0].value)")
                    }.frame(minWidth: 50, maxWidth: 340, minHeight: 20, maxHeight: 20, alignment: .topLeading)
                    Group{
                        Text("Vision field test status (Left eye): ")
                        Text("\(visionFieldTestLeftEyeTuple[0].value)")
                        Text("Vision field test status (Right eye): ")
                        Text("\(visionFieldTestRightEyeTuple[0].value)")
                    }.frame(minWidth: 50, maxWidth: 340, minHeight: 20, maxHeight: 20, alignment: .topLeading)
                    Group{
                        Text("Color Vision test status (Left eye): ")
                            .frame(minWidth: 50, maxWidth: 340, minHeight: 20, maxHeight: 20, alignment: .topLeading)
                        Text("\(colorVisionTestLeftEyeTuple[0].value)")
                            .frame( alignment: .topLeading)
                        Text("Color Vision test status (Right eye): ")
                            .frame(minWidth: 50, maxWidth: 340, minHeight: 20, maxHeight: 20, alignment: .topLeading)
                        Text("\(colorVisionTestRightEyeTuple[0].value)")
                            .frame( alignment: .topLeading)
                    }
                } else {
                    Text(String(format: NSLocalizedString("YouCompletedXEyeTestText %d", comment: ""), eyeTestCount))
                        .padding()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    LineView(data: visualAcuityTestLeftEyeTuple, data2: visualAcuityTestRightEyeTuple, title: "Visual Acuity Test Result", type: "Number", graphType: .Visual_Acuity_Test_1, focusedGraph: $focusedGraph)
                        .padding(.horizontal)
                        .frame(minWidth: 50, maxWidth: 300, minHeight: 480, maxHeight: 480)
                    LineView(data: astigmatismTestLeftEyeTuple, data2: astigmatismTestRightEyeTuple, title: "Astigmatism Test Result", type: "Binary", graphType: .Astigmatism_Test_2, focusedGraph: $focusedGraph)
                        .padding(.horizontal)
                        .frame(minWidth: 50, maxWidth: 300, minHeight: 480, maxHeight: 480)
                    LineView(data: visionFieldTestLeftEyeTuple, data2: visionFieldTestRightEyeTuple, title: "Vision Field Test Result", type: "Binary", graphType: .Vision_Field_Test_3, focusedGraph: $focusedGraph)
                        .padding(.horizontal)
                        .frame(minWidth: 50, maxWidth: 300, minHeight: 480, maxHeight: 480)
                    LineView(data: colorVisionTestRedGreenColorBlindnessLeftEyeTuple, data2: colorVisionTestRedGreenColorBlindnessRightEyeTuple, title: "Red-green Colour Sensivity", type: "Binary", graphType: .Red_Green_Color_Sensitivity_4, focusedGraph: $focusedGraph)
                        .padding(.horizontal)
                        .frame(minWidth: 50, maxWidth: 300, minHeight: 480, maxHeight: 480)
                    LineView(data: colorVisionTestRedBlackColorBlindnessLeftEyeTuple, data2: colorVisionTestRedBlackColorBlindnessRightEyeTuple, title: "Red-black Colour Sensivity", type: "Binary", graphType: .Red_Black_Color_Sensitivity_5, focusedGraph: $focusedGraph)
                        .padding(.horizontal)
                        .frame(minWidth: 50, maxWidth: 300, minHeight: 480, maxHeight: 480)
                    LineView(data: colorVisionTestRedSensitivityLeftEyeTuple, data2: colorVisionTestRedSensitivityRightEyeTuple, title: "Red Colour Sensivity", type: "Binary", graphType: .Red_Color_Sensitivity_6, focusedGraph: $focusedGraph)
                        .padding(.horizontal)
                        .frame(minWidth: 50, maxWidth: 300, minHeight: 480, maxHeight: 480)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 70)  
        }
        .onAppear {
            for testResult in user.testResults {
                visualAcuityTestLeftEyeTuple.append((date: (testResult["date"] ?? ""), value: Double(testResult["visual_acuity_test_left_message"] ?? "0.1") ?? 0.1))
                visualAcuityTestRightEyeTuple.append((date: (testResult["date"] ?? ""), value: Double(testResult["visual_acuity_test_right_message"] ?? "0.1") ?? 0.1))
                
                astigmatismTestLeftEyeTuple.append((date: (testResult["date"] ?? ""), value: Double(((testResult["astigmatism_test_left_message"] ?? "") == "Normal") ? 0 : 1)))
                astigmatismTestRightEyeTuple.append((date: (testResult["date"] ?? ""), value: Double(((testResult["astigmatism_test_rigth_message"] ?? "") == "Normal") ? 0 : 1)))
                
                visionFieldTestLeftEyeTuple.append((date: (testResult["date"] ?? ""), value: (testResult["vision_field_test_left_message"] ?? "") == "Normal" ? 0 : 1))
                visionFieldTestRightEyeTuple.append((date: (testResult["date"] ?? ""), value: (testResult["vision_field_test_right_message"] ?? "") == "Normal" ? 0 : 1))
                
                colorVisionTestLeftEyeTuple.append((date: (testResult["date"] ?? ""), value: (testResult["colour_blind_test_left_message"] ?? "")))
                colorVisionTestRightEyeTuple.append((date: (testResult["date"] ?? ""), value: (testResult["colour_blind_test_right_message"] ?? "")))
                
                
                colorVisionTestRedGreenColorBlindnessLeftEyeTuple
                    .append((date: (testResult["date"] ?? "")
                             , value: Double((testResult["colour_blind_test_left_message"] ?? "").contains("red-green colour blindness") ? 1 : 0)))
                colorVisionTestRedGreenColorBlindnessRightEyeTuple
                    .append((date: (testResult["date"] ?? "")
                             , value: Double((testResult["colour_blind_test_right_message"] ?? "").contains("red-green colour blindness") ? 1 : 0)))
                
                colorVisionTestRedBlackColorBlindnessLeftEyeTuple
                    .append((date: (testResult["date"] ?? "")
                             , value: Double((testResult["colour_blind_test_left_message"] ?? "").contains("red-black colour blindness") ? 1 : 0)))
                colorVisionTestRedBlackColorBlindnessRightEyeTuple
                    .append((date: (testResult["date"] ?? "")
                             , value: Double((testResult["colour_blind_test_right_message"] ?? "").contains("red-black colour blindness") ? 1 : 0)))
                
                colorVisionTestRedSensitivityLeftEyeTuple
                    .append((date: (testResult["date"] ?? "")
                             , value: Double((testResult["colour_blind_test_left_message"] ?? "").contains("low sensitivity to red colour") ? 1 : 0)))
                colorVisionTestRedSensitivityRightEyeTuple
                    .append((date: (testResult["date"] ?? "")
                             , value: Double((testResult["colour_blind_test_right_message"] ?? "").contains("low sensitivity to red colour") ? 1 : 0)))
                
            }
            eyeTestCount = visualAcuityTestLeftEyeTuple.count
        }
        .navigationBarHidden(true)
        .overlay(alignment: .top) {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Text("DoneText")
                        .fontWeight(.bold)
                        .padding()
                }
             }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .overlay(alignment: .center) {
                Text("ViewResultTitle")
                    .bold()
                    .font(.system(size: 20))
            }
        }
    }
}

enum ViewResultGraphType: Int {
    case Visual_Acuity_Test_1=1, Astigmatism_Test_2, Vision_Field_Test_3, Red_Green_Color_Sensitivity_4, Red_Black_Color_Sensitivity_5, Red_Color_Sensitivity_6
}

struct ViewResultView_Previews: PreviewProvider {
    static var previews: some View {
        ViewResultView()
    }
}
