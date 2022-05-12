

import SwiftUI

public struct LineView: View {
    @ObservedObject var data: ChartData
    @ObservedObject var data2: ChartData
    public var title: String?
    public var legend: String?
    public var style: ChartStyle
    public var style2: ChartStyle
    public var darkModeStyle: ChartStyle
    public var valueSpecifier: String
    public var legendSpecifier: String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var closestPoint2: CGPoint = .zero
    @State private var opacity:Double = 0.0
    @State private var currentDataNumber: Double = 0
    @State private var currentDataNumber2: Double = 0
    @State private var currentDataDate: String = "0"
    @State private var hideHorizontalLines: Bool = false
    
    @State private var magnifierLocation: CGPoint = .zero   //added
    
    private var type: String? = "Number"
    
    private var selfGraph: ViewResultGraphType
    @Binding var focusedGraph: ViewResultGraphType
    
    init(data: [(String, Double)],
                data2: [(String, Double)],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                style2: ChartStyle = Styles.lineViewDarkMode,
                valueSpecifier: String? = "%.1f",
                legendSpecifier: String? = "%.2f",
                type: String? = nil,
                graphType: ViewResultGraphType,
                focusedGraph: Binding<ViewResultGraphType>) {
        
        self.data = ChartData(values: data)
        self.data2 = ChartData(values: data2)
        self.title = title
        self.legend = legend
        self.style = style
        self.style2 = style2
        self.valueSpecifier = valueSpecifier!
        self.legendSpecifier = legendSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.type = type
        self.selfGraph = graphType
        self._focusedGraph = focusedGraph
        self.loseFocus()
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .center) {
                
                RoundedRectangle(cornerRadius: 16)
                    .frame(width:geometry.size.width*1.2 , height: geometry.size.height*0.9)
                    .foregroundColor(Color.white)
                    .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
                    .blendMode(.multiply)
                
                VStack(alignment: .leading) {
                    
                    //                    Group{
                    //                        if (self.title != nil){
                    //                            Text(self.title!)
                    //                                .font(.title)
                    //                                .bold().foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    //                        }
                    //                        if (self.legend != nil){
                    //                            Text(self.legend!)
                    //                                .font(.title)
                    //                                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    //                        }
                    //                    }.offset(x: 0, y: 0)
                    Text(self.title!)
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    Text(self.currentDataDate)
                        .font(.system(size: 18))
                        .opacity(self.currentDataDate == "0" ? 0 : 1)
                    
//                    Text("Left Eye: " + String(self.currentDataNumber))
//                        .font(.system(size: 18))
//                    Text("Right Eye: " + self.currentDataDate)
//                        .font(.system(size: 18))
                    Text("test")
                        .font(.system(size: 50))
                        .opacity(0)
                    
                    ZStack{
                        
                        GeometryReader{ reader in
                            
                            //                        Rectangle()
                            //                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                            if(self.showLegend){
                                
                                Legend(data: self.data,
                                       frame: .constant(reader.frame(in: .local)), hideHorizontalLines: self.$hideHorizontalLines, specifier: legendSpecifier, type: self.type)
                                    .transition(.opacity)
//                                    .animation(Animation.easeOut(duration: 1).delay(1))
                            }
                            Line(lineColor: Color.red,
                                 data: self.data,
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
                                 touchLocation: self.$closestPoint, // changed from $indicatorLocation
                                 showIndicator: self.$hideHorizontalLines,
                                 minDataValue: .constant(0),
                                 maxDataValue: .constant(nil),
                                 showBackground: false,
                                 type: self.type,
                                 gradient: self.style.gradientColor
                            )
                                .offset(x: 30, y: 0)
                                .onAppear(){
                                    self.showLegend = true
                                }
                                .onDisappear(){
                                    self.showLegend = false
                                }
                            
                            Line(lineColor: Color.blue,
                                 data: self.data2,
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
                                 touchLocation: self.$closestPoint,
                                 showIndicator: self.$hideHorizontalLines,
                                 minDataValue: .constant(0),
                                 maxDataValue: .constant(nil),
                                 showBackground: false,
                                 type: self.type,
                                 gradient: self.style2.gradientColor
                            )
                                .offset(x: 30, y: 0)
                                .onAppear(){
                                    self.showLegend = true
                                }
                                .onDisappear(){
                                    self.showLegend = false
                                }
                            
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: 240)
                        .offset(x: 0, y: 0 )
                        MagnifierRect(currentNumber: self.$currentDataNumber, currentNumber2: self.$currentDataNumber2, type: self.type, valueSpecifier: self.valueSpecifier)
                            .opacity(self.opacity)
                            .offset(x: self.magnifierLocation.x - geometry.frame(in: .local).size.width/2.5, y: 36)
                        //                        Details(currentDate: self.$currentDataDate)
                        //                            .opacity(self.opacity)
                        //                            .offset(x: -20, y: -50)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 240)
                    .gesture(DragGesture()
                                .onChanged({ value in
                        self.dragLocation = value.location
                        self.indicatorLocation = CGPoint(x: max(value.location.x-30,0), y: 32)
                        self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width-30, height: 240)
                        self.closestPoint2 = self.getClosestDataPoint2(toPoint: value.location, width: geometry.frame(in: .local).size.width-30, height: 240)
                        
                        if (closestPoint.x > 240) {
                            magnifierLocation = CGPoint(x: 240, y: closestPoint.y)
                        } else {
                            magnifierLocation = closestPoint
                        }
                        focusedGraph = selfGraph
                        getFocus()
                    })
//                        .onEnded({ value in
//                            self.opacity = 0
//                            self.hideHorizontalLines = false
//                        })
                    )
                }
            }
            .position(x:geometry.size.width/2 , y: geometry.size.height/2)
            .onChange(of: focusedGraph) { newValue in
                if newValue != selfGraph {
                    loseFocus()
                }
            }
        }
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let dates = self.data.onlyDates()   // added
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if index < 0 {
            return CGPoint(x: CGFloat(0)*stepWidth, y: CGFloat(points[0])*stepHeight)
        }
        else if index >= points.count {
            return CGPoint(x: CGFloat(points.count-1)*stepWidth, y: CGFloat(points[points.count-1])*stepHeight)
        }
        else if (index >= 0 && index < points.count){
            self.currentDataNumber = points[index]
            self.currentDataDate = dates[index]     // added
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
    
    func getClosestDataPoint2(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data2.onlyPoints()
        let dates = self.data2.onlyDates()   // added
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if index < 0 {
            return CGPoint(x: CGFloat(0)*stepWidth, y: CGFloat(points[0])*stepHeight)
        }
        else if index >= points.count {
            return CGPoint(x: CGFloat(points.count-1)*stepWidth, y: CGFloat(points[points.count-1])*stepHeight)
        }
        else if (index >= 0 && index < points.count){
            self.currentDataNumber2 = points[index]
            self.currentDataDate = dates[index]     // added
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
    
    private func getFocus() {
        self.opacity = 1
        self.hideHorizontalLines = true
    }
    
    private func loseFocus() {
        self.opacity = 0
        self.hideHorizontalLines = false
        self.currentDataDate = "0"
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            LineView(data: [8,2,54,32,10,2,7,20,43], title: "test", style: Styles.lineChartStyleOne)
            //
            //            LineView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188], title: "Full chart", style: Styles.lineChartStyleOne)
            
        }
    }
}

