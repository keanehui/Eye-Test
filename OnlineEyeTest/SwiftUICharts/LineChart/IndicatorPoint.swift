

import SwiftUI

struct IndicatorPoint: View {
    var indicatorColor = Color.red
    
    var body: some View {
        ZStack{
            Circle()
                .fill(indicatorColor)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3))
        }
        .frame(width: 14, height: 14)
//        .shadow(color: Colors.LegendColor, radius: 6, x: 0, y: 6)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint()
    }
}
