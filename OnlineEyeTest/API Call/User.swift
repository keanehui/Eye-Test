//
//  User.swift
//  SigninV2
//
//  Created by FYP on 21/1/2022.
//

import Foundation

class User : ObservableObject {
    static let shared = User()
    
    @Published var isLogin: Bool
    @Published var token: String
    @Published var userID: String
    @Published var testResults: [Dictionary<String, String>]
    
    init() {
        isLogin = false
        token = ""
        userID = ""
        testResults = [Dictionary<String, String>]()
    }
    
//    var serverURL = "https://hkust-onlineeyetest-api.com"
    var serverURL = "http://18.166.219.225:3000"
    
    typealias SignupCompletion = (_ result: SignupResult) -> ()
    func Signup(username: String, password: String, onComplete: @escaping SignupCompletion) {
        // hash
        let params = ["username":username, "password":password, "admin":true] as Dictionary<String, AnyObject>

        var request = URLRequest(url: URL(string: serverURL + "/users/signup")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode == 200 {
                    onComplete(.success)
                } else if statusCode == 500 {
                    self.Logout()
                    onComplete(.failure)
                } else {
                    self.Logout()
                    onComplete(.unknownFailure)
                }
            } else {
                self.Logout()
                onComplete(.networkFailure)
            }
        })
        task.resume()
    }
    
    typealias LoginCompletion = (_ result: LoginResult) -> ()
    func Login(username: String, password: String, onComplete: @escaping LoginCompletion) {
        // hash
        let params = ["username":username, "password":password] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: serverURL + "/users/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if statusCode == 200 {
                        let json = try JSONSerialization.jsonObject(with: data ?? Data()) as! Dictionary<String, AnyObject>
                        print("Login json: \n\(json)")
                        DispatchQueue.main.async {
                            self.token = json["token"] as? String ?? ""
                            let decodedJWT = self.decode(jwtToken: self.token)
                            self.userID = decodedJWT["_id"] as? String ?? ""
                            self.isLogin = true
                            onComplete(.success)
                        }
                    } else if statusCode == 401 {
                        self.Logout()
                        onComplete(.authFailure)
                    } else {
                        self.Logout()
                        onComplete(.unknownFailure)
                    }
                } else {
                    self.Logout()
                    onComplete(.networkFailure)
                }
            } catch {
                print("error in login. \(error.localizedDescription)")
                self.Logout()
                onComplete(.unknownFailure)
            }
        })
        task.resume()
    }
    
    func Logout() {
        DispatchQueue.main.async {
            self.isLogin = false
            self.token = ""
            self.userID = ""
            self.testResults = [Dictionary<String, String>]()
        }
    }
}

extension User {
    
    typealias AddNewTestResultCompletion = (_ result: AddNewDataResult) -> ()
    func AddNewTestResult(resultList:[TestResultBox], onComplete: @escaping AddNewTestResultCompletion) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm YYYY/MM/dd "
        let dateString = dateFormatter.string(from: Date())
        let params = ["colour_blind_test_left_status":resultList[0].leftEyeStatus.rawValue
                      ,"colour_blind_test_right_status":resultList[0].rightEyeStatus.rawValue
                      ,"colour_blind_test_left_message":resultList[0].leftEyeMessage
                      ,"colour_blind_test_right_message":resultList[0].rightEyeMessage
                      ,"visual_acuity_test_left_status":resultList[1].leftEyeStatus.rawValue
                      ,"visual_acuity_test_right_status":resultList[1].rightEyeStatus.rawValue
                      ,"visual_acuity_test_left_message":resultList[1].leftEyeMessage
                      ,"visual_acuity_test_right_message":resultList[1].rightEyeMessage
                      ,"astigmatism_test_left_status":resultList[2].leftEyeStatus.rawValue
                      ,"astigmatism_test_right_status":resultList[2].rightEyeStatus.rawValue
                      ,"astigmatism_test_left_message":resultList[2].leftEyeMessage
                      ,"astigmatism_test_rigth_message":resultList[2].rightEyeMessage
                      ,"vision_field_test_left_status":resultList[3].leftEyeStatus.rawValue
                      ,"vision_field_test_right_status":resultList[3].rightEyeStatus.rawValue
                      ,"vision_field_test_left_message":resultList[3].leftEyeMessage
                      ,"vision_field_test_right_message":resultList[3].rightEyeMessage
                      , "date": dateString] as! Dictionary<String, String>
        var request = URLRequest(url: URL(string: serverURL + "/users/" + self.userID + "/test_results")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("bearer " + self.token, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if statusCode == 200 {
                        let _ = try JSONSerialization.jsonObject(with: data ?? Data()) as! Dictionary<String, AnyObject>
                        onComplete(.success)
                    } else {
                        onComplete(.failure)
                    }
                } else {
                    onComplete(.networkFailure)
                }
            } catch {
                print("error in add new result. \(error.localizedDescription)")
                onComplete(.failure)
            }
        })
        task.resume()
    }
    
    typealias GetAllTestResultsCompletion = (_ result: GetTestDataResult) -> ()
    func GetAllTestResults(onComplete: @escaping GetAllTestResultsCompletion) {
        
        var request = URLRequest(url: URL(string: serverURL + "/users/" + self.userID + "/test_results")!)
        request.httpMethod = "GET"
        // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("bearer " + self.token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if statusCode == 200 {
                        let json = try JSONSerialization.jsonObject(with: data ?? Data()) as! [Dictionary<String, String>]
                        DispatchQueue.main.async {
                            self.testResults = json
                            print("Get Test Results Complete")
                            onComplete(.success)
                        }
                    } else {
                        onComplete(.failure)
                    }
                } else {
                    onComplete(.networkFailure)
                }
            } catch {
                print("error in get results. \(error.localizedDescription)")
                onComplete(.failure)
            }
        })
        task.resume()
    }
    
    
    
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
    
    
    enum LoginResult {
        case success, authFailure, networkFailure, unknownFailure
    }
    
    enum SignupResult {
        case success, failure, networkFailure, unknownFailure
    }
    
    enum AddNewDataResult {
        case success, failure, networkFailure
    }
    
    enum GetTestDataResult {
        case success, failure, networkFailure
    }
    
}

