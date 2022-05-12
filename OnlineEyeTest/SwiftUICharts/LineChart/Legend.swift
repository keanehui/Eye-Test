
import SwiftUI

struct Legend: View {
    @ObservedObject var data: ChartData
    @Binding var frame: CGRect
    @Binding var hideHorizontalLines: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var specifier: String = "%.2f"
    let padding:CGFloat = 3
    
    @State var type: String? = "Number"
    
    var stepWidth: CGFloat {
        if data.points.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.points.count-1)
    }
    var stepHeight: CGFloat {
        if (type == "Number") {
            return (frame.size.height-padding) / CGFloat(1.33 - 0.1)
        } else {
            return (frame.size.height-padding) / CGFloat(1 - 0)
        }
//        let points = self.data.onlyPoints()
//        if let min = points.min(), let max = points.max(), min != max {
//            if (min < 0){
//                return (frame.size.height-padding) / CGFloat(max - min)
//            }else{
//                return (frame.size.height-padding) / CGFloat(max - min)
//            }
//        }
//        return 0
    }
    
    var min: CGFloat {
        if (type == "Number"){
            return CGFloat(0.1)
        } else {
            return CGFloat(0)
        }
//        let points = self.data.onlyPoints()
//        return CGFloat(points.min() ?? 0)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            if (type == "Number") {
                //                var array = [0.2, 0.4, 0.5, 0.8, 1.25]
                ForEach(0...4, id: \.self) { height in
                    HStack(alignment: .center){
                        Text("\(self.getYLegendSafe(height: height), specifier: specifier)").offset(x: 0, y: self.getYposition(height: height) )
                            .foregroundColor(Colors.LegendText)
                            .font(.caption)
                        self.line(atHeight: self.getYLegendSafe(height: height), width: self.frame.width)
                            .stroke(self.colorScheme == .dark ? Colors.LegendDarkColor : Colors.LegendColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5,height == 0 ? 0 : 10]))
                        //                            .opacity((self.hideHorizontalLines && height != 0) ? 0 : 1)
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        //                            .animation(.easeOut(duration: 0.2))
                            .clipped()
                    }
                    
                }
            }
            else {
                
                ForEach(Array(stride(from: 0, to: 5, by: 4)), id: \.self) { height in
                    HStack(alignment: .center){
                        if (height == 0) {
                            Text("Normal").offset(x: -10, y: self.getYposition(height: height) + 10 )
                                .foregroundColor(Colors.LegendText)
                                .font(.caption)
                        } else {
                            Text("Abnormal").offset(x: -10, y: self.getYposition(height: height) - 10 )
                                .foregroundColor(Colors.LegendText)
                                .font(.caption)
                        }
                        self.line(atHeight: self.getYLegendSafe(height: height), width: self.frame.width)
                            .stroke(self.colorScheme == .dark ? Colors.LegendDarkColor : Colors.LegendColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5,height == 0 ? 0 : 10]))
//                            .opacity((self.hideHorizontalLines && height != 0) ? 0 : 1)
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        //                            .animation(.easeOut(duration: 0.2))
                            .clipped()
                    }
                    
                }
            }
            
            
            
        }
    }
    
    func getYLegendSafe(height:Int)->CGFloat{
        if let legend = getYLegend() {
            return CGFloat(legend[height])
        }
        return 0
    }
    
    func getYposition(height: Int)-> CGFloat {
        if let legend = getYLegend() {
            return (self.frame.height-((CGFloat(legend[height]) - min)*self.stepHeight))-(self.frame.height/2)
        }
        return 0
        
    }
    
    func line(atHeight: CGFloat, width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x:5, y: (atHeight-min)*stepHeight))
        hLine.addLine(to: CGPoint(x: width, y: (atHeight-min)*stepHeight))
        return hLine
    }
    
    func getYLegend() -> [Double]? {
        let points = self.data.onlyPoints()
        guard let max = points.max() else { return nil }
        guard let min = points.min() else { return nil }
        var step = Double(max - min)/4
        if (self.type == "Number") {
            step = Double(1.33 - 0.1) / 4
            return [0.1, 0.1+step, 0.1+step*2, 0.1+step*3, 0.1+step*4]
        } else {
            step = Double(1 - 0) / 4
            return [0, 0+step, 0+step*2, 0+step*3, 0+step*4]
        }
//        return [min+step * 0, min+step * 1, min+step * 2, min+step * 3, min+step * 4]
    }
}

struct Legend_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            Legend(data: ChartData(points: [0.2,0.4,1.4,4.5]), frame: .constant(geometry.frame(in: .local)), hideHorizontalLines: .constant(false))
        }.frame(width: 320, height: 200)
    }
}