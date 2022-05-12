//
//  LeftRightEyeView.swift
//  OnlineEyeTest
//
//  Created by FYP on 3/2/2022.
//

import SwiftUI

struct ResultView:View{
    @State private var isPresenting: Bool = false
    
    public var result:TestResultBox
    public var colourblindmessage0:String = resultList[0].leftEyeMessage.components(separatedBy: ",")[0]
    public var colourblindmessage1:String = resultList[0].leftEyeMessage.components(separatedBy: ",")[1]
    public var colourblindmessage2:String = resultList[0].leftEyeMessage.components(separatedBy: ",")[2]
    
    public var cbttext1:String = resultList[0].rightEyeMessage.components(separatedBy: ",")[0]
    public var cbttext2:String = resultList[0].rightEyeMessage.components(separatedBy: ",")[1]
    public var cbttext3:String = resultList[0].rightEyeMessage.components(separatedBy: ",")[2]
    
    
    var body: some View{
        VStack{
            Text(result.test.name)
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(5)
            Divider()
            HStack(spacing: 15){
                VStack{
                    switch(result.leftEyeStatus){
                        case .good:
                            Image("eye")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50,height:30)
                        case .fair:
                            Image("eye.trianglebadge.exclamationmark-1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50,height:30)
                        default:
                            Image("eye.trianglebadge.exclamationmark-2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50,height:30)
                    }
                    Text("Left Eye").modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 16, fontColor: .gray))
                    Divider()
                    if(result.test == .ColorBlindTest_1){
                        if(self.colourblindmessage0 != " "){
                        Text(self.colourblindmessage0).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.primary))
                            .frame(maxWidth: 135, minHeight:40,maxHeight: .infinity, alignment: .center)
                            .padding(5)
                        }
                        if(self.colourblindmessage1 != " "){
                            Text(self.colourblindmessage1).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.primary))
                            .frame(maxWidth: 135, minHeight:40,maxHeight: .infinity, alignment: .center)
                            .padding(5)
                        }
                        if(self.colourblindmessage2 != " "){
                            Text(self.colourblindmessage2).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.primary))
                            .frame(maxWidth: 135, minHeight:40,maxHeight: .infinity, alignment: .center)
                            .padding(5)
                        }
                    }
                    else{
                        Text(result.leftEyeMessage).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 20, fontColor: Color.primary))
                            .padding(5)
                    }
                    
                }
                
                VStack{
                    switch(result.rightEyeStatus){
                        case .good:
                            Image("eye")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50,height:30)
                            
                        case .fair:
                            Image("eye.trianglebadge.exclamationmark-1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50,height:30)
                        default:
                            Image("eye.trianglebadge.exclamationmark-2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50,height:30)
                    }
                    Text("Right Eye").modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 16, fontColor: .gray))
                    Divider()
                    if(result.test == .ColorBlindTest_1){
                        if(self.cbttext1 != " "){
                        Text(self.cbttext1).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.primary))
                            .frame(maxWidth: 135, minHeight:40,maxHeight: .infinity, alignment: .center)
                            .padding(5)
                        }
                        if(self.cbttext2 != " "){
                            Text(self.cbttext2).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.primary))
                            .frame(maxWidth: 135, minHeight:40,maxHeight: .infinity, alignment: .center)
                            .padding(5)
                        }
                        if(self.cbttext3 != " "){
                            Text(self.cbttext3).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.primary))
                            .frame(maxWidth: 135, minHeight:40,maxHeight: .infinity, alignment: .center)
                            .padding(5)
                        }
                    }
                    else{
                        Text(result.rightEyeMessage).modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 20, fontColor: Color.primary))
                            .padding(5)
                    }
                }
                
            }
            if(self.result.test == .VisualAcuityTest_3){
                Button {
                    isPresenting = true
                } label: {
                    Text("What does it mean? ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                }

            }
            
        }
        //.border(Color.black,width: 2)
        .sheet(isPresented: $isPresenting) {
            ResultViewExplaination()
        }
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ResultView(result: TestResultBox(test: .ColorBlindTest_1, leftEyeStatus: .fair, rightEyeStatus: .bad, leftEyeMessage: "left message", rightEyeMessage: "right message"))
//        }
//    }
//}


