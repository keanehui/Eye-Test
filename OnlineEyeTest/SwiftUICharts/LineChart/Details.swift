
import SwiftUI

public struct Details: View {
    @Binding var currentDate: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    public var body: some View {
        ZStack{
            
            Text(self.currentDate)
                .font(.system(size: 18, weight: .bold))
                .offset(x: 0, y:-90)
                .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            
            
        }
        .offset(x: 0, y: -15)
    }
}
