//
//  ColourFieldTestViewModel.swift
//  OnlineEyeTest
//
//  Created by FYP on 30/1/2022.
//

import SwiftUI

class VisionFieldTestViewModel:ObservableObject{
    static func createVisionFieldTestModel() -> VisionFieldTestModel{
        VisionFieldTestModel(initimage: "VisualFieldTestImage")
    }
    
    @Published private var model:VisionFieldTestModel = createVisionFieldTestModel()
    
    var image : String{
        model.testimage
    }
    
    func InputLeftEyeAnswer(inputanswer:Bool){
        model.InputLeftEyeAnswer(inputanswer: inputanswer)
    }
    
    func InputRightEyeAnswer(inputanswer:Bool){
        model.InputRightEyeAnswer(inputanswer: inputanswer)
    }
    func generateResult(){
        model.generateResult()
    }
}
