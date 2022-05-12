//
//  VisionFieldTestModel.swift
//  OnlineEyeTest
//
//  Created by FYP on 30/1/2022.
//

import Foundation

struct VisionFieldTestModel{
    private(set) var testimage: String
    private var leftEyeAnswer: Bool
    private var rightEyeAnswer: Bool
    
    //result
    private(set) var result:TestResultBox = TestResultBox(test: .VisionFieldTest_5, leftEyeStatus:.good , rightEyeStatus:.good, leftEyeMessage: "", rightEyeMessage:"" )
    
    mutating func InputLeftEyeAnswer(inputanswer: Bool){
        self.leftEyeAnswer = inputanswer
        if(leftEyeAnswer){
            print("VisualFieldTest test leftEyeAnswer : True")
        }else{
            print("VisualField test leftEyeAnswer : False")
        }
    }
    
    mutating func InputRightEyeAnswer(inputanswer: Bool){
        self.rightEyeAnswer = inputanswer
        if(rightEyeAnswer){
            print("VisualFieldTest test rightEyeAnswer : True")
        }else{
            print("VisualField test rightEyeAnswer : False")
        }
    }
    
    mutating func generateResult(){
        if(leftEyeAnswer){
            result.leftEyeStatus = .good
            result.leftEyeMessage = "Normal"
        }else{
            result.leftEyeStatus = .bad
            result.leftEyeMessage = "Abnormal"
        }
        
        if(rightEyeAnswer){
            result.rightEyeStatus = .good
            result.rightEyeMessage = "Normal"
        }else{
            result.rightEyeStatus = .bad
            result.rightEyeMessage = "Abnormal"
        }
        resultList.append(result)
    }
    
    init(initimage: String){
        testimage = initimage
        leftEyeAnswer = true
        rightEyeAnswer = true
    }
}
