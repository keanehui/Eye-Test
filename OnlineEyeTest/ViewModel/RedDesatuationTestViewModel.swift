//
//  RedDesatuationTestViewModel.swift
//  OnlineEyeTest
//

import SwiftUI

class RedDesatuationTestViewModel:ObservableObject{
    static func createRedDesatuationTest() -> RedDesatuationTestModel{
        RedDesatuationTestModel()
    }
    
    @Published private var model:RedDesatuationTestModel = createRedDesatuationTest()
    
    var image : String{
        model.testimage
    }
    
    func InputAnswer(inputanswer:Bool){
        model.InputAnswer(inputanswer: inputanswer)
    }
    
    func generateResult(){
        model.generateResult()
    }
}
