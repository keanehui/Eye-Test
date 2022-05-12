//
//  AstigmatismTestModel.swift
//  OnlineEyeTest
//

enum EyeStatus: String {
    case bad, fair, good
}

import Foundation

struct TestResultBox{
    private(set) var test: EyeTestType
    public var leftEyeStatus: EyeStatus
    public var rightEyeStatus: EyeStatus
    public var leftEyeMessage: String
    public var rightEyeMessage: String
}
