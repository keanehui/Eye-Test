//
//  MenuView.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 14/4/2022.
//

import SwiftUI

struct MenuView: View {
    @Binding var pageControl: LaunchViewPageControl
    @ObservedObject var appState: AppState
    @State private var isLoading: Bool = false
    @State private var isGoingToCalibration: Bool = false
    @State private var isResultsReady: Bool = false
    @State private var isPresentingAlertLogout: Bool = false
    @State private var isPresentingAlertGetResultsFailed: Bool = false
    @State private var isPresentingAlertNetworkFailure: Bool = false
    @ObservedObject var user = User.shared
    @Environment(\.colorScheme) var colorScheme
    
    private var gradientThemeColor: Color {
        return colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.yellow, gradientThemeColor]), center: .center, startRadius: 2, endRadius: 1000)
                .edgesIgnoringSafeArea(.all)
            Alerts
            VStack {
                Spacer()
                NavigationLink(destination: CalibrationIntroView(appState: appState), isActive: $isGoingToCalibration) {}.frame(width: 0, height: 0)
                ButtonStart
                Spacer()
                ButtonViewResult
                Spacer()
            }
            NavigationLink(destination: ViewResultView(), isActive: $isResultsReady) {}
                .frame(width: 0, height: 0)
        }
        .overlay(alignment: .center) {
            if isLoading {
                LoadingView()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                isPresentingAlertLogout = true
            } label: {
                Text("LogoutButtonText")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(minWidth: 60)
            .padding(10)
            .background(.red)
            .cornerRadius(15)
            .padding()
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}

extension MenuView {
    
    private var ButtonStart: some View {
        Button {
            HapticManager.shared.impact(style: .medium)
            isGoingToCalibration = true
        } label: {
            Image("start")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:280,height:150)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                .overlay(alignment: .bottomTrailing) {
                    Text("StartButtonText")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .blue)
                    .padding(5)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    .padding(10)
                }
                
        }
    }
    
    private var ButtonViewResult: some View {
        Button {
            HapticManager.shared.impact(style: .medium)
            viewResults()
        } label: {
            ZStack {
                Image("viewresult2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:280,height:150)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .overlay(alignment: .bottomLeading) {
                        Text("ViewResultButtonText")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .blue)
                        .padding(5)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                        .padding(10)
                    }
            }
        }
    }
    
    private func viewResults() {
        isResultsReady = false
        isLoading = true
        DispatchQueue.main.async {
            user.GetAllTestResults { result in
                isLoading = false
                switch result {
                case .success:
                    isResultsReady = true
                case .failure:
                    isResultsReady = false
                    isPresentingAlertGetResultsFailed = true
                case .networkFailure:
                    isResultsReady = false
                    isPresentingAlertNetworkFailure = true
                }
            }
        }
    }
    
    private var Alerts: some View {
        ZStack {
            Circle()
                .alert("AlertAreYouSureTitle", isPresented: $isPresentingAlertLogout) {
                    Button("LogoutButtonText", role: .destructive) {
                        print("user click log out.")
                        withAnimation {
                            user.Logout()
//                            pageControl = .LoginView
                        }
                    }
                    Button("CancelButtonText", role: .cancel) {
                    }
                }
            Circle()
                .alert("AlertViewResultsFailedTitle", isPresented: $isPresentingAlertGetResultsFailed) {
                    Button {} label: {
                        Text("OKButton")
                    }
                } message: {
                    Text("AlertFetchResultsErrorMessage")
                }
            Circle()
                .alert(isPresented: $isPresentingAlertNetworkFailure) {
                    Alert(title: Text("AlertViewResultsFailedTitle"), message: Text("AlertNetworkFailureMessage"), dismissButton: .default(Text("OKButton")))
                }
        }
        .frame(width: 0, height: 0)
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(pageControl: .constant(.MenuView), appState: AppState())
    }
}
