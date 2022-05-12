//
//  ScreenOne.swift
//  SigninV2


import SwiftUI

struct SignUpView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @State private var isLoading: Bool = false
    @State private var isFocused: Bool = false
    @State private var isPresentingAlertTextFieldRequired: Bool = false
    @State private var isPresentingAlertTextFieldConfirmation: Bool = false
    @State private var isPresentingAlertUnknownFailure: Bool = false
    @State private var isPresentingAlertNetworkFailure: Bool = false
    @State private var isPresentingAlertSuccess: Bool = false
    @State private var isPresentingAlertFailure: Bool = false
    @FocusState private var focusedField: FocusedField?
    
    @ObservedObject var user = User.shared
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    private var isTextfieldFilled: Bool {
        if username == "" || password == "" || confirmpassword == "" {
            return false
        } else {
            return true
        }
    }
    
    private var isPasswordMatched: Bool {
        return password == confirmpassword
    }
    
    var body: some View {
        VStack {
            Alerts
            if !isFocused {
                Text("CreateAccountText")
                    .modifier(CustomTextM(fontName: "Oxygen-Bold", fontSize: 35, fontColor: Color("blue")))
                    .padding(.top, 100)
                    .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.3)), removal: .opacity.animation(.easeInOut(duration: 0.1))))
            }
            VStack(alignment: .center, spacing: 50) {
                UsernameTextField
                    .submitLabel(.next)
                PasswordTextField
                    .submitLabel(.next)
                ConfirmTextField
                    .submitLabel(.go)
            }
            .onSubmit {
                if focusedField == .username {
                    focusedField = .password
                } else if focusedField == .password {
                    focusedField = .confirm
                } else {
                    focusedField = nil
                    self.signup()
                }
            }
            .padding(.top, 50)
            Spacer()
            Button {
                self.signup()
            } label: {
                Text("SignupButtonText")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.green, in: RoundedRectangle(cornerRadius: 15))
                    .foregroundColor(.white)
            }
            .disabled(isLoading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            focusedField = nil
        }
        .onChange(of: focusedField) { newValue in
            withAnimation {
                if newValue == nil {
                    isFocused = false
                } else {
                    isFocused = true
                }
            }
        }
        .overlay(alignment: .center) {
            if isLoading {
                LoadingView()
            }
        }
        .overlay(alignment: .topLeading, content: {
            if !isFocused {
                Button(role: .destructive) {
                    user.Logout()
                    dismiss()
                } label: {
                    Text("CancelButtonText")
                        .padding()
                }
                .transition(.opacity.animation(.easeInOut))
            }
        })
        .navigationBarHidden(true)
    }
    
    private func signup() {
        focusedField = nil
        if !isTextfieldFilled {
            isPresentingAlertTextFieldRequired = true
            return
        }
        if !isPasswordMatched {
            isPresentingAlertTextFieldConfirmation = true
            password = ""
            confirmpassword = ""
            return
        }
        isLoading = true
        self.user.Signup(username: username, password: password) { result in
            isLoading = false
            switch result {
            case .success:
                isPresentingAlertSuccess = true
                print("Signup result: \(result)")
            case .failure:
                username = ""
                password = ""
                confirmpassword = ""
                isPresentingAlertFailure = true
                print("Signup result: \(result)")
            case .networkFailure:
                isPresentingAlertNetworkFailure = true
                print("Signup result: \(result)")
            case .unknownFailure:
                isPresentingAlertUnknownFailure = true
                print("Signup result: \(result)")
            }
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

extension SignUpView {
    
    private var textFieldThemeColor: Color {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    private var UsernameTextField: some View {
        TextField("UsernamePlaceholder", text: $username)
            .focused($focusedField, equals: .username)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding([.leading, .trailing])
            .background(focusedField == .username ? Material.thin : .ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
            .overlay(alignment: .topLeading) {
                Image(systemName: "person")
                    .foregroundColor(focusedField == .username ? .blue : textFieldThemeColor)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .offset(x: 15, y: -30)
            }
            .overlay(alignment: .trailing) {
                if username != "" {
                    Button {
                        username = ""
                        focusedField = .username
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    }
                    .offset(x: -10, y: 0)
                }
            }
    }
    
    private var PasswordTextField: some View {
        SecureField("PasswordPlaceholder", text: $password)
            .focused($focusedField, equals: .password)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding([.leading, .trailing])
            .background(focusedField == .password ? Material.thin : .ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
            .overlay(alignment: .topLeading) {
                Image(systemName: "lock")
                    .foregroundColor(focusedField == .password ? .blue : textFieldThemeColor)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .offset(x: 15, y: -30)
            }
            .overlay(alignment: .trailing) {
                if password != "" {
                    Button {
                        password = ""
                        confirmpassword = ""
                        focusedField = .password
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    }
                    .offset(x: -10, y: 0)
                }
            }
    }
    
    private var ConfirmTextField: some View {
        SecureField("ConfirmPlaceholder", text: $confirmpassword)
            .focused($focusedField, equals: .confirm)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding([.leading, .trailing])
            .background(focusedField == .confirm ? Material.thin : .ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
            .overlay(alignment: .topLeading) {
                Image(systemName: "lock.fill")
                    .foregroundColor(focusedField == .confirm ? .blue : textFieldThemeColor)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .offset(x: 15, y: -30)
            }
            .overlay(alignment: .trailing) {
                if confirmpassword != "" {
                    Button {
                        confirmpassword = ""
                        focusedField = .confirm
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    }
                    .offset(x: -10, y: 0)
                }
            }
    }
    
    private var Alerts: some View {
        ZStack {
            Circle()
                .alert(isPresented: $isPresentingAlertTextFieldRequired) {
                    Alert(title: Text("AlertSignupFailTitle"), message: Text("AlertSignupPasswordRequiredMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert(isPresented: $isPresentingAlertTextFieldConfirmation) {
                    Alert(title: Text("AlertSignupFailTitle"), message: Text("AlertSignupPasswordDoNotMatchMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert("AlertSignupSuccessTitle", isPresented: $isPresentingAlertSuccess) {
                    Button {
                        dismiss()
                    } label: {
                        Text("OKButton")
                    }
                } message: {
                    Text("AlertSignupSuccessMessage")
                }
            Circle()
                .alert(isPresented: $isPresentingAlertFailure) {
                    Alert(title: Text("AlertSignupFailTitle"), message: Text("AlertSignupUsernameIsUsedMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert(isPresented: $isPresentingAlertNetworkFailure) {
                    Alert(title: Text("AlertSignupFailTitle"), message: Text("AlertNetworkFailureMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert(isPresented: $isPresentingAlertUnknownFailure) {
                    Alert(title: Text("AlertSignupFailTitle"), message: Text("AlertUnknownErrorMessage"), dismissButton: .default(Text("OKButton")))
                }
        }
        .frame(width: 0, height: 0)
    }
    
    enum FocusedField {
        case username, password, confirm
    }
    
}

struct CustomTextM: ViewModifier {
    //MARK:- PROPERTIES
    let fontName: String
    let fontSize: CGFloat
    let fontColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
            .foregroundColor(fontColor)
    }
}
