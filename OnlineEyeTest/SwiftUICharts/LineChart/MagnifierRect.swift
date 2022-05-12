

import SwiftUI

public struct MagnifierRect: View {
    @Binding var currentNumber: Double
    @Binding var currentNumber2: Double
//    @Binding var currentDate: String
    
    @State var type: String?
    
    var valueSpecifier:String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    public var body: some View {
        ZStack{
            if (self.colorScheme == .dark){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: self.colorScheme == .dark ? 2 : 0)
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.white)
                        .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
                        .blendMode(.multiply)
                }
                .frame(width: 135, height: 330)
                
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 135, height: 330)
                    .foregroundColor(Color.white)
                    .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
                    .blendMode(.multiply)
            }
            
            if (type == "Number") {
                (
                    Text("Left: \(String(currentNumber))")
                        .foregroundColor(Color.red) +
                    Text("\nRight: \(String(currentNumber2))")
                        .foregroundColor(Color.blue)
                )
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .multilineTextAlignment(.trailing)
                .padding(5)
                .background(.white)
                .cornerRadius(5)
                .offset(x: 0, y: -125)
            } else {
                let leftStatus: String = currentNumber == 1 ? "Abnormal" : "Normal"
                let rightStatus: String = currentNumber2 == 1 ? "Abnormal" : "Normal"
                (
                    Text("Left: \(leftStatus)")
                        .foregroundColor(Color.red) +
                    Text("\nRight: \(rightStatus)")
                        .foregroundColor(Color.blue)
                )
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .multilineTextAlignment(.trailing)
                .padding(5)
                .background(.white)
                .cornerRadius(5)
                .offset(x: 0, y: -130)
            }
//
//            Text(self.currentDate)
//                .font(.system(size: 18, weight: .bold))
//                .offset(x: 0, y:-90)
//                .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
//
            
            
        }
        .offset(x: 0, y: -70)
    }
}
