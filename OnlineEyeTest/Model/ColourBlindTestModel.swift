//
//  ColourBlindTestModel.swift
//  OnlineEyeTest
//


import Foundation
import SwiftUI
var testImageSet1 : [String] = ["Ishihara-Plate-1-6","Ishihara-Plate-1-8","Ishihara-Plate-1-29","Ishihara-Plate-1-57"]
var testImageSet2 : [String] = ["Ishihara-Plate-2-3","Ishihara-Plate-2-5","Ishihara-Plate-2-15","Ishihara-Plate-2-74"]
var testImageSet3 : [String] = ["Ishihara-Plate-3-26","Ishihara-Plate-3-35","Ishihara-Plate-3-42","Ishihara-Plate-3-96"]

struct ColourBlindTestModel{

    private(set) var testimage: String
    
    private var leftEyeAnswer : [Int] = []
    private var rightEyeAnswer : [Int] = []
    
    private var leftModelAnswer : [Int] = []
    private var rightModelAnswer : [Int] = []
    
    private(set) var leftEyeFinishedTest: Int = 0
    private(set) var rightEyeFinishedTest: Int = 0
    
    //result
    private(set) var result:TestResultBox = TestResultBox(test: .ColorBlindTest_1, leftEyeStatus:.good , rightEyeStatus:.good, leftEyeMessage: "", rightEyeMessage:"" )
    
    mutating func InputLeftEyeAnswer(inputanswer: Int){
        self.leftEyeAnswer.append(inputanswer)
        leftEyeFinishedTest+=1
        changeTestImage()
        
        //debug messages
        print("Colour Blind test answer (left eye)added: " + String(leftEyeAnswer[leftEyeFinishedTest-1]))
        print(leftEyeAnswer)
        print(leftEyeFinishedTest)
        //debug messages
    }
    
    mutating func InputRightEyeAnswer(inputanswer: Int){
        self.rightEyeAnswer.append(inputanswer)
        rightEyeFinishedTest+=1
        changeTestImage()
        
        //debug messages
        print("Colour Blind test answer (right eye)added: " + String(rightEyeAnswer[rightEyeFinishedTest-1]))
        print(rightEyeAnswer)
        print(rightEyeFinishedTest)
        //debug messages
    }
    
    mutating func changeTestImage(){
        if(leftEyeFinishedTest<3){
            switch(leftEyeFinishedTest){
            case 1:
                let randomNumber = Int.random(in: 0..<4)
                testimage = testImageSet2[randomNumber]
                leftModelAnswer.append(Int(testimage.components(separatedBy: "-")[3]) ?? -1)
//                testImageSet2.remove(at: randomNumber)
            case 2:
                let randomNumber = Int.random(in: 0..<4)
                testimage = testImageSet3[randomNumber]
                leftModelAnswer.append(Int(testimage.components(separatedBy: "-")[3]) ?? -1)
//                testImageSet3.remove(at: randomNumber)
            default:
                print("default")
            }
        }else{
            switch(rightEyeFinishedTest){
            case 0:
                let randomNumber = Int.random(in: 0..<3)
                testimage = testImageSet1[randomNumber]
                rightModelAnswer.append(Int(testimage.components(separatedBy: "-")[3]) ?? -1)
//                testImageSet1.remove(at: randomNumber)
            case 1:
                let randomNumber = Int.random(in: 0..<3)
                testimage = testImageSet2[randomNumber]
                rightModelAnswer.append(Int(testimage.components(separatedBy: "-")[3]) ?? -1)
//                testImageSet2.remove(at: randomNumber)
            case 2:
                let randomNumber = Int.random(in: 0..<3)
                testimage = testImageSet3[randomNumber]
                rightModelAnswer.append(Int(testimage.components(separatedBy: "-")[3]) ?? -1)
//                testImageSet3.remove(at: randomNumber)
            default:
                print("finsihed Colour Blind Test")
            }
        }
    }
    
    mutating func generateResult(){
        var leftEyeWrong = 0;
        var rightEyeWrong = 0;
        for i in 0..<leftEyeFinishedTest{
            if(leftEyeAnswer[i] != leftModelAnswer[i]){
                leftEyeWrong+=1
            }
        }
        if(leftEyeWrong>1){
            result.leftEyeStatus = .bad
        }else if(leftEyeWrong == 1){
            result.leftEyeStatus = .fair
        }
        
        for j in 0..<leftEyeFinishedTest{
            if(rightEyeAnswer[j] != rightModelAnswer[j]){
                rightEyeWrong+=1
            }
        }
        if(rightEyeWrong>1){
            result.rightEyeStatus = .bad
        }else if(rightEyeWrong == 1){
            result.rightEyeStatus = .fair
        }
        
        if(leftEyeAnswer[0] != leftModelAnswer[0] || leftEyeAnswer[1] != leftModelAnswer[1]){
            result.leftEyeMessage.append("red-green colour blindness,")
        }else{
            result.leftEyeMessage.append(" ,")
        }
        if(leftEyeAnswer[2] != leftModelAnswer[2]){
            result.leftEyeMessage.append("red-black colour blindness,")
        }else{
            result.leftEyeMessage.append(" ,")
        }
        
        
        if(rightEyeAnswer[0] != rightModelAnswer[0] || rightEyeAnswer[1] != rightModelAnswer[1]){
            result.rightEyeMessage.append("red-green colour blindness,")
        }else{
            result.rightEyeMessage.append(" ,")
        }
        if(rightEyeAnswer[2] != rightModelAnswer[2]){
            result.rightEyeMessage.append("red-black colour blindness,")
        }else{
            result.rightEyeMessage.append(" ,")
        }
        
        print(leftModelAnswer)
        print(rightModelAnswer)
        print(result.leftEyeStatus)
        print(result.rightEyeStatus)
        resultList.append(result)
    }
    
    init(initimage: String){
        testimage = initimage
        leftModelAnswer.append(Int(initimage.components(separatedBy: "-")[3]) ?? -1)
//        if let index = testImageSet1.firstIndex(of: initimage) {
//  //          testImageSet1.remove(at: index)
//        }
    }
}
