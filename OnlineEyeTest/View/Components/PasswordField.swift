
import SwiftUI

struct PasswordField: View {
    //MARK:- PROPERTIES    
    var placeholder: String
    var fontName: String
    var fontSize: CGFloat
    var fontColor: Color
    
    @Binding var password: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        SecureField(placeholder, text: $password, onCommit: commit)
            .foregroundColor(.primary)
    }
}

