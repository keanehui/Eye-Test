//
//  AstigmatismTestModel.swift
//  OnlineEyeTest
//

import Foundation

struct AstigmatismTestModel{
    private(set) var testimage: String
    private var leftAnswer: Bool
    private var rightAnswer: Bool
    
    //result
    private(set) var result:TestResultBox = TestResultBox(test: .AstigmatismTest_4, leftEyeStatus:.good , rightEyeStatus:.good, leftEyeMessage: "", rightEyeMessage:"" )
    
    mutating func InputLeftEyeAnswer(inputanswer: Bool){
        self.leftAnswer = inputanswer
        if(leftAnswer){
            print("Astigmatism test leftEyeAnswer : True")
        }else{
            print("Astigmatism test leftEyeAnswer : False")
        }
    }
    
    mutating func InputRightEyeAnswer(inputanswer: Bool){
        self.rightAnswer = inputanswer
        if(rightAnswer){
            print("Astigmatism test rightEyeAnswer : True")
        }else{
            print("Astigmatism test rightEyeAnswer : False")
        }
    }
    
    mutating func generateResult(){
        if(leftAnswer){
            result.leftEyeStatus = .good
            result.leftEyeMessage = "Normal"
        }else{
            result.leftEyeStatus = .bad
            result.leftEyeMessage = "Abnormal"
        }
        
        if(rightAnswer){
            result.rightEyeStatus = .good
            result.rightEyeMessage = "Normal"
        }else{
            result.rightEyeStatus = .bad
            result.rightEyeMessage = "Abormal"
        }
        resultList.append(result)
    }
    
    init(initimage: String){
        testimage = initimage
        leftAnswer = true
        rightAnswer = true
    }
}
