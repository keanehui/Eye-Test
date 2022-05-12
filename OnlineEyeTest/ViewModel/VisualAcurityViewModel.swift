//
//  ColourBlindTestViewModel.swift
//  OnlineEyeTest
//
import SwiftUI

class VisualAcurityTestViewModel:ObservableObject{
    static func createVATModel() -> VisualAcurityTestModel{
        VisualAcurityTestModel()
    }
    
    @Published private var model:VisualAcurityTestModel = createVATModel()
    
    var image1 : String{
        model.testimage1
    }
    
    var image2 : String{
        model.testimage2
    }
    
    var image3 : String{
        model.testimage3
    }
    
    var image4 : String{
        model.testimage4
    }
    
    var leftEyefinsihedTest:Int{
        model.leftEyeFinishedTest
    }
    
    var rightEyefinsihedTest:Int{
        model.rightEyeFinishedTest
    }
    
    var leftEyeLevel:Int{
        model.leftEyeLevel
    }
    
    var rightEyeLevel:Int{
        model.rightEyeLevel
    }
    
    var currentEye: VisualAcurityTestModelEye {
        model.currentEye
    }
    
    func InputLeftEyeAnswer(inputanswer:String)->Bool{
        return model.InputLeftEyeAnswer(inputanswer: inputanswer)
    }
    
    func InputRightEyeAnswer(inputanswer:String)->Bool{
        return model.InputRightEyeAnswer(inputanswer: inputanswer)
    }
    
    func generateResult(){
        model.generateResult()
    }
}

