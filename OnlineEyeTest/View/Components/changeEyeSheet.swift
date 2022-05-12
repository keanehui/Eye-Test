
import Swift
import SwiftUI
struct ChangeEyeSheet:View{
    @Binding var showSheet:Bool
    var body:some View{
        VStack(alignment: .center){
            Button(action:{
                self.showSheet = false
            }){
                Image(systemName: "x.circle").font(.title)
            }
            .frame(minWidth: 0,maxWidth: .infinity,alignment: .topTrailing)
            .padding()
            Spacer()
            GeometryReader{geometry in
                VStack{
                    HStack{
                        Image("eye.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:60,height:60)
                            .padding(.horizontal)
                        Image("eye")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:60,height:60)
                            .padding(.horizontal)
                    
                    }
                    Text("Switch to Right Eye")
                        .font(.title2)
                        .padding(.horizontal, 30.0)
                        .padding(.vertical,10)
                        .background(Color.white)
                    
                    Button(action:{
                        self.showSheet = false
                    }
                           , label:{
                        Text("Confirm")
                            .font(.title2)
                            .padding(.horizontal, 30.0)
                            .padding(.vertical,10)
                            .background(Color.white)
                        
                    }).border(Color.blue,width: 3)
                        .cornerRadius(6)
                        .shadow(color: .blue, radius: 2, x: 0.0, y: 0.0)
                }.position(x: geometry.size.width/2, y: geometry.size.height*40/100)
            }
            
            Spacer()
        }
    }   
}
