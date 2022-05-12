//
//  ResultView.swift
//  OnlineEyeTest
//
//  Created by FYP on 6/2/2022.
//

import SwiftUI


var resultList:[TestResultBox] = []

struct ResultListView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var user = User.shared
    
    @State private var isPresentingAlertAddNewResultFailure: Bool = false
    @State private var isPresentingAlertAddNewResultNetworkFailure: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack{
            Alerts
            if resultList.count > 0 {
                List {
                    Text("").listRowBackground(Color.clear) // place holder
                    Section{
                        ResultView(result: resultList[0])
                    }
                    Section{
                        ResultView(result: resultList[1])
                    }
                    Section{
                        ResultView(result: resultList[2])
                    }
                    Section{
                        ResultView(result: resultList[3])
                    }
                }
            } else {
                Text("NoResultText")
                    .bold()
                    .font(.largeTitle)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .overlay(alignment: .center) {
            if isLoading {
                LoadingView()
            }
        }
        .overlay(alignment: .top) {
            HStack(spacing: 0) {
                Button {
                    uploadResult()
                } label: {
                    Text("DoneText")
                        .fontWeight(.bold)
                        .padding()
                }
             }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .overlay(alignment: .center) {
                Text("ResultOverviewText")
                    .bold()
                    .font(.system(size: 20))
            }
        }
    }
    
    private var Alerts: some View {
        ZStack {
            Circle()
                .alert("AlertUploadFailedTitle", isPresented: $isPresentingAlertAddNewResultFailure) {
                    Button(role: .destructive) {
                        backtoMenu()
                    } label: {
                        Text("LeaveText")
                    }
                } message: {
                    Text("AlertUploadFailedUnknownErrorMessage")
                }
            Circle()
                .alert("AlertUploadFailedTitle", isPresented: $isPresentingAlertAddNewResultNetworkFailure) {
                    Button(role: .destructive) {
                        backtoMenu()
                    } label: {
                        Text("LeaveText")
                    }
                } message: {
                    Text("AlertUploadFailedNetworkErrorMessage")
                }
        }
        .frame(width: 0, height: 0)
    }
    
    private func uploadResult() {
        isLoading = true
        user.AddNewTestResult(resultList: resultList) { result in
            isLoading = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm YYYY/MM/dd "
            let dateString = dateFormatter.string(from: Date())
            switch result {
            case .success:
                backtoMenu()
                print("result uploade. success. at \(dateString)")
            case .failure:
                isPresentingAlertAddNewResultFailure = true
                print("result uploade. fail. at \(dateString)")
            case .networkFailure:
                isPresentingAlertAddNewResultNetworkFailure = true
                print("result uploade. network fail. at \(dateString)")
            }
        }
    }
    
    private func backtoMenu() {
        resultList.removeAll()
        DispatchQueue.main.async {
            appState.rootViewId = UUID()
        }
    }
}
