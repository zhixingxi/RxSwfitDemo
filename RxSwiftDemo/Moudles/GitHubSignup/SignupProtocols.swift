//
//  SignupProtocols.swift
//  RxSwiftDemo
//
//  Created by 孟庆岭 on 2018/11/25.
//  Copyright © 2018 IT A. All rights reserved.
//

import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case validing
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok(_):
            return true
        default:
            return false
        }
    }
}

enum SignupState {
    case signedUp(signedUp: Bool)
}

/// API 接口协议
protocol GitHubAPI {
    func usernameAvailable(username: String) -> Observable<Bool>
    func signUp(username: String, password: String) -> Observable<Bool>
}

/// 有效性验证协议
protocol GitHubValidationService {
    func validateUsername(username: String) -> Observable<ValidationResult>
    func validatePassword(password: String) -> ValidationResult
    func validateRepeatedPassword(password: String, repeatPassword: String) -> ValidationResult
}
