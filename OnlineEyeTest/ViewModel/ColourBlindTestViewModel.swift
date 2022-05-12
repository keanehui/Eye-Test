//
//  ColourBlindTestViewModel.swift
//  OnlineEyeTest
//
import SwiftUI

class ColourBlindTestViewModel:ObservableObject{
    static func createColourBlindTestModel() -> ColourBlindTestModel{
        ColourBlindTestModel(initimage: testImageSet1[Int.random(in: 0..<4)])
    }
    
    private var model:ColourBlindTestModel = createColourBlindTestModel()
    
    var image : String{
        model.testimage
    }
    
    var leftEyefinsihedTest:Int{
        model.leftEyeFinishedTest
    }
    
    var rightEyefinsihedTest:Int{
        model.rightEyeFinishedTest
    }
    
    func InputLeftEyeAnswer(inputanswer:Int){
        model.InputLeftEyeAnswer(inputanswer: inputanswer)
    }
    
    func InputRightEyeAnswer(inputanswer:Int){
        model.InputRightEyeAnswer(inputanswer: inputanswer)
    }
    
    func generateResult(){
        model.generateResult()

    }
}
