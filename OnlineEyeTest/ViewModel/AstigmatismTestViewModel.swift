//
//  AstigmatismTestViewModel.swift
//  OnlineEyeTest
//
import SwiftUI

class AstigmatismTestViewModel:ObservableObject{
    static func createAstigmatism() -> AstigmatismTestModel{
        AstigmatismTestModel(initimage: "astigmatism")
    }
    
    @Published private var model:AstigmatismTestModel = createAstigmatism()
    
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


