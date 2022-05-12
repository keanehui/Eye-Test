
import SwiftUI

struct LoginView: View {
    @Binding var pageControl: LaunchViewPageControl
    @State var username: String = ""
    @State var password: String = ""
    @State var isFocus: Bool = false
    @State private var isLoading: Bool = false
    @State private var isPresentingAlertTextFieldRequired: Bool = false
    @State private var isPresentingAlertAuthFailed: Bool = false
    @State private var isPresentingAlertNetworkFailure: Bool = false
    @State private var isPresentingAlertUnknownFailure: Bool = false
    @State private var isPresentingSheet: Bool = false
    @FocusState private var focusedField: FocusedField?
    
    @ObservedObject var user = User.shared
    
    private var isTextfieldFilled: Bool {
        if username == "" || password == "" {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 2, endRadius: 1000)
                .ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }
            Alerts
            VStack{
                Spacer()
                if !isFocus {
                    Text("TopicText")
                        .modifier(CustomTextM(fontName: "Oxygen-Bold", fontSize: 50, fontColor: Color.white))
                        .onTapGesture {
                            focusedField = nil
                        }
                        .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.3)), removal: .opacity.animation(.easeInOut(duration: 0.1))))
                    Spacer()
                }
                VStack(spacing: 50) {
                    UsernameTextField
                        .submitLabel(.next)
                    PasswordTextField
                        .submitLabel(.go)
                }
                .onAppear {
                    username = ""
                    password = ""
                }
                .onDisappear {
                    isLoading = false
                }
                .onSubmit {
                    if focusedField == .username {
                        focusedField = .password
                    } else {
                        self.login()
                    }
                }
                LoginButton
                    .padding(.top, 50)
                NavigationLink(destination:SignUpView()){
                    Text("SignUpButtonText")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.teal)
                        .padding()
                }
                .disabled(isLoading)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal,20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .center) {
            if isLoading {
                LoadingView()
            }
        }
        .overlay(alignment: .bottom) {
            if !isFocus {
                Button {
                    isPresentingSheet = true
                } label: {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("SettingsButtonText")
                            .bold()
                    }
                    .foregroundColor(.gray)
                }
                .disabled(isLoading)
            }
        }
        .sheet(isPresented: $isPresentingSheet) {
            SettingView()
        }
        .onChange(of: focusedField) { newValue in
            withAnimation {
                if newValue == nil {
                    isFocus = false
                } else {
                    isFocus = true
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(pageControl: .constant(.LoginView))
    }
}

extension LoginView {
    private var UsernameTextField: some View {
        CustomTextfield(placeholder: Text("UsernameText"), fontName: "NunitoSans-Regular", fontSize: 16, fontColor: Color.white, foregroundColor: Color.white, username: $username)
            .focused($focusedField, equals: .username)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding([.leading, .trailing])
            .background(focusedField == .username ? Material.thin : .ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
            .disabled(isLoading)
            .overlay(alignment: .topLeading) {
                Image(systemName: focusedField == .username ? "person.fill" : "person")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .offset(x: 15, y: -30)
                    .onTapGesture { // DEBUG
                        username = "T"
                        password = "t"
                    }
            }
            .overlay(alignment: .trailing) {
                if username != "" {
                    Button {
                        username = ""
                        focusedField = .username
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                    .offset(x: -10, y: 0)
                }
            }
    }
    
    private var PasswordTextField: some View {
        LoginPassword(placeholder: Text("PasswordText"), fontName: "NunitoSans-Regular", fontSize: 16, fontColor: Color.white, password: $password)
            .focused($focusedField, equals: .password)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding([.leading, .trailing])
            .background(focusedField == .password ? Material.thin : .ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
            .disabled(isLoading)
            .overlay(alignment: .topLeading) {
                Image(systemName: focusedField == .password ? "lock.fill" : "lock")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .offset(x: 15, y: -30)
            }
            .overlay(alignment: .trailing) {
                if password != "" {
                    Button {
                        password = ""
                        focusedField = .password
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                    .offset(x: -10, y: 0)
                }
            }
    }
    
    private var LoginButton: some View {
        Button {
            HapticManager.shared.impact(style: .medium)
            self.login()
        } label: {
            Text("LoginButtonText")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding()
                .frame(maxWidth: .infinity)
                .background(.cyan, in: RoundedRectangle(cornerRadius: 15))
        }
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .disabled(isLoading)
    }
    
    private var Alerts: some View {
        ZStack {
            Circle()
                .alert(isPresented: $isPresentingAlertTextFieldRequired) {
                    Alert(title: Text("AlertLoginFailedTitle"), message: Text("AlertRequiredMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert(isPresented: $isPresentingAlertAuthFailed) {
                    Alert(title: Text("AlertLoginFailedTitle"), message: Text("AlertPasswordIncorrectMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert(isPresented: $isPresentingAlertNetworkFailure) {
                    Alert(title: Text("AlertLoginFailedTitle"), message: Text("AlertNetworkFailureMessage"), dismissButton: .default(Text("OKButton")))
                }
            Circle()
                .alert(isPresented: $isPresentingAlertUnknownFailure) {
                    Alert(title: Text("AlertLoginFailedTitle"), message: Text("AlertUnknownErrorMessage"), dismissButton: .default(Text("OKButton")))
                }
        }
        .frame(width: 0, height: 0)
    }
    
    private func login() {
        focusedField = nil
        if !isTextfieldFilled {
            isPresentingAlertTextFieldRequired = true
            return
        }
        
        isLoading = true
        self.user.Login(username: username, password: password) { result in
            isLoading = false
            switch result {
            case .success:
                print("Login result: \(result)")
            case .authFailure:
                isPresentingAlertAuthFailed = true
                password = ""
                print("Login result: \(result)")
            case .networkFailure:
                isPresentingAlertNetworkFailure = true
                print("Login result: \(result)")
            case .unknownFailure:
                isPresentingAlertUnknownFailure = true
                print("Login result: \(result)")
            }
        }
    }
    
    enum FocusedField {
        case username, password
    }
}
