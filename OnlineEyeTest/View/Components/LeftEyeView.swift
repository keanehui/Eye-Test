//
//  LeftRightEyeView.swift
//  OnlineEyeTest
//
//  Created by FYP on 3/2/2022.
//

// NOT IN USE

import SwiftUI

struct LeftEyeView:View{
    var body: some View{
        VStack{
            Text("Observe the following image with your left eye only")
                .modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 20, fontColor: Color.primary))
            HStack{
                Image("eye")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:60,height:60)
                    .padding(.horizontal)
            
                Image("eye.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:60,height:60)
                    .padding(.horizontal)
            }
        }
    }
}

struct LeftEyeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LeftEyeView()
        }
    }
}

