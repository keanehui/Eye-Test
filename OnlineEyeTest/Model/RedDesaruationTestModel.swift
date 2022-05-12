//
//  OnlineEyeTest
//
//

import Foundation

struct RedDesatuationTestModel{
    private(set) var testimage: String = "red_desatuation"
    private var Answer: Bool
    
    mutating func InputAnswer(inputanswer: Bool){
        self.Answer = inputanswer
        if(Answer){
            print("RedDesatuationTest test Answer : True")
        }else{
            print("RedDesatuationTest test Answer : False")
        }
    }

    mutating func generateResult(){
        if(Answer){
            resultList[0].leftEyeStatus = .bad
            resultList[0].rightEyeStatus = .bad
            resultList[0].leftEyeMessage.append("low sensitivity to red colour")
            resultList[0].rightEyeMessage.append("low sensitivity to red colour")
        }else{
            resultList[0].leftEyeMessage.append(" ")
            resultList[0].rightEyeMessage.append(" ")
        }
    }
    
    init(){
        self.Answer = false
    }
}
