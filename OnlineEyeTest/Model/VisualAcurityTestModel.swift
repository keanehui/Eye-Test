import Foundation
var VATdataSet : [[String]] = [["VST1"],
                               ["VST2"],
                               ["VST3"],
                               ["VST4"],
                               ["VST5_DCEF","VST5_FCPD","VST5_PEFD"],
                               ["VST6_DFCZP","VST6_ECPDF"]
]

var newDataSet : [String] = ["A","D","F","H","K","M","N","O","P","R","T","U","X","Y"]
var VATwordSize : [Int] = [24,20,16,14,12,10,8,7,6,5]

enum VisualAcurityTestModelEye: Int {
    case Left=1, Right
}

struct VisualAcurityTestModel{
    private(set) var testimage1: String
    private(set) var testimage2: String
    private(set) var testimage3: String
    private(set) var testimage4: String
    private(set) var leftEyeAnswer : [[Character]] = []
    private(set) var rightEyeAnswer : [[Character]] = []
    private(set) var leftEyeFinishedTest: Int = 0
    private(set) var rightEyeFinishedTest: Int = 0
    private(set) var leftModelAnswer : [[Character]]
    private(set) var rightModelAnswer : [[Character]] = []
    private(set) var leftEyeLevel:Int = 0
    private(set) var rightEyeLevel:Int = 0
    private(set) var currentEye: VisualAcurityTestModelEye = .Left
    
    private(set) var incorrectCountLeft:Int = 0
    private(set) var incorrectCountRight:Int = 0
    //result
    private(set) var result:TestResultBox = TestResultBox(test: .VisualAcuityTest_3, leftEyeStatus:.good , rightEyeStatus:.good, leftEyeMessage: "", rightEyeMessage:"" )
    
    mutating func InputLeftEyeAnswer(inputanswer: String)->Bool{
        print("run input left eye answer")
        if(Array(inputanswer).count==4){
            self.leftEyeAnswer.append(Array(inputanswer))
            if(leftEyeAnswer[leftEyeFinishedTest] == leftModelAnswer[leftEyeFinishedTest]){
                if(leftEyeLevel<9){
                    leftEyeLevel += 1
                    generateNewImage()
                    leftModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                }else{
                    generateNewImage()
                    rightModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                    self.currentEye = .Right
                    return true
                }
                if(leftEyeFinishedTest>=2){
                    if(leftEyeAnswer[leftEyeFinishedTest-1] == leftModelAnswer[leftEyeFinishedTest-1]){
                        incorrectCountLeft = 0
                    }
                }
            }else{
                if(leftEyeLevel==0 && incorrectCountLeft==0){
                    generateNewImage()
                    leftModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                    incorrectCountLeft = 1
                }else if(leftEyeLevel>0 && incorrectCountLeft==0){
                    generateNewImage()
                    leftModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                    leftEyeLevel -= 1
                    incorrectCountLeft = 1
                }else{
                    generateNewImage()
                    rightModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                    self.currentEye = .Right
                    return true
                }
                
                
            }
            leftEyeFinishedTest+=1
            //debug messages
            print(leftEyeAnswer)
            print(leftEyeFinishedTest)
            //debug messages
        }
        return false
    }
    
    mutating func InputRightEyeAnswer(inputanswer: String)->Bool{
        print("run input right eye answer")
        if(Array(inputanswer).count==4){
            self.rightEyeAnswer.append(Array(inputanswer))
            if(rightEyeAnswer[rightEyeFinishedTest] == rightModelAnswer[rightEyeFinishedTest]){
                if(rightEyeLevel<9){
                    rightEyeLevel += 1
                    generateNewImage()
                    rightModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                }else{
                    return true
                }
                if(rightEyeFinishedTest>=2){
                    if(rightEyeAnswer[rightEyeFinishedTest-1] == rightModelAnswer[rightEyeFinishedTest-1]){
                        incorrectCountRight = 0
                    }
                }
                
            }else{
                
                if(rightEyeLevel==0 && incorrectCountRight==0){
                    generateNewImage()
                    rightModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                    incorrectCountRight = 1
                }else if(leftEyeLevel>0 && incorrectCountRight==0){
                    generateNewImage()
                    rightModelAnswer.append( [Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)])
                    rightEyeLevel -= 1
                    incorrectCountRight = 1
                }else{
                    return true
                }
            }
            rightEyeFinishedTest+=1
            //debug messages
        }
        print(rightEyeAnswer)
        print(rightEyeFinishedTest)
        //debug messages
        return false
    }
    
    
    func printAnswer(answer: [[Int]]){
        for i in 0..<answer.count{
            for j in 0..<answer[i].count{
                print(answer[i][j])
                print(",")
            }
            print("\n")
        }
    }
    
    init(){
        let randomNumber1 = Int.random(in: 0..<14)
        let randomNumber2 = Int.random(in: 0..<14)
        let randomNumber3 = Int.random(in: 0..<14)
        let randomNumber4 = Int.random(in: 0..<14)
        testimage1 = newDataSet[randomNumber1]
        testimage2 = newDataSet[randomNumber2]
        testimage3 = newDataSet[randomNumber3]
        testimage4 = newDataSet[randomNumber4]
        leftModelAnswer = [[Character(testimage1),Character(testimage2),Character(testimage3),Character(testimage4)]]
    }
    
    func getResult()->TestResultBox{
        return self.result
    }
    
    mutating func generateResult(){
        switch(self.leftEyeLevel){
        case 0:
            self.result.leftEyeStatus = .bad
            self.result.leftEyeMessage = "0.1"
        case 1:
            self.result.leftEyeStatus = .bad
            self.result.leftEyeMessage = "0.2"
        case 2:
            self.result.leftEyeStatus = .fair
            self.result.leftEyeMessage = "0.28"
        case 3:
            self.result.leftEyeStatus = .fair
            self.result.leftEyeMessage = "0.4"
        case 4:
            self.result.leftEyeStatus = .fair
            self.result.leftEyeMessage = "0.5"
        case 5:
            self.result.leftEyeStatus = .fair
            self.result.leftEyeMessage = "0.66"
        case 6:
            self.result.leftEyeStatus = .good
            self.result.leftEyeMessage = "0.8"
        case 7:
            self.result.leftEyeStatus = .good
            self.result.leftEyeMessage = "1"
        case 8:
            self.result.leftEyeStatus = .fair
            self.result.leftEyeMessage = "1.33"
        default:
            self.result.leftEyeStatus = .good
        }
        
        
        switch(self.rightEyeLevel){
        case 0:
            self.result.rightEyeStatus = .bad
            self.result.rightEyeMessage = "0.1"
        case 1:
            self.result.rightEyeStatus = .bad
            self.result.rightEyeMessage = "0.2"
        case 2:
            self.result.rightEyeStatus = .fair
            self.result.rightEyeMessage = "0.28"
        case 3:
            self.result.rightEyeStatus = .fair
            self.result.rightEyeMessage = "0.4"
        case 4:
            self.result.rightEyeStatus = .fair
            self.result.rightEyeMessage = "0.5"
        case 5:
            self.result.rightEyeStatus = .fair
            self.result.rightEyeMessage = "0.66"
        case 6:
            self.result.rightEyeStatus = .good
            self.result.rightEyeMessage = "0.8"
        case 7:
            self.result.rightEyeStatus = .good
            self.result.rightEyeMessage = "1"
        case 8:
            self.result.rightEyeStatus = .fair
            self.result.rightEyeMessage = "1.33"
        default:
            self.result.rightEyeStatus = .good
        }
        resultList.append(result)
    }
    
    mutating func generateNewImage(){
        let randomNumber1 = Int.random(in: 0..<14)
        let randomNumber2 = Int.random(in: 0..<14)
        let randomNumber3 = Int.random(in: 0..<14)
        let randomNumber4 = Int.random(in: 0..<14)
        testimage1 = newDataSet[randomNumber1]
        testimage2 = newDataSet[randomNumber2]
        testimage3 = newDataSet[randomNumber3]
        testimage4 = newDataSet[randomNumber4]
    }
    
}

