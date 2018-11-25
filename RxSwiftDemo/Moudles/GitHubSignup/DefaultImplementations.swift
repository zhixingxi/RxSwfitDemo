
//
//  DefaultImplementations.swift
//  RxSwiftDemo
//
//  Created by 孟庆岭 on 2018/11/25.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 有效性验证实现
class GitHubDefaultValidationService {
    
    let API: GitHubAPI

    init(API: GitHubAPI) {
        self.API = API
    }
    
    let minPasswordCount = 5
    
}

extension GitHubDefaultValidationService: GitHubValidationService {
    func validateUsername(username: String) -> Observable<ValidtionResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return Observable.just(ValidtionResult.failed(message: "Username can only contain numbers or digits"))
        }
        
        let loadingValue = ValidtionResult.validing
        return API
            .usernameAvailable(username: username)
            .map({ (available) -> ValidtionResult in
                if available {
                    return ValidtionResult.ok(message: "Username available")
                }
                return ValidtionResult.failed(message: "Username already taken")
            })
            .startWith(loadingValue)
    }
    
    func calidatePassword(password: String) -> ValidtionResult {
        let passwordCount = password.count
        if passwordCount == 0 {
            return .empty
        }
        if passwordCount < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        return .ok(message: "Password acceptable")
    }
    
    func validateRepeatedPassword(password: String, repeatPassword: String) -> ValidtionResult {
        if repeatPassword.count == 0 {
            return .empty
        }
        
        if repeatPassword == password  {
            return .ok(message: "Password repeated")
        }
        return ValidtionResult.failed(message: "Password different")
    }
}


/// API 协议实现
class GitHubDefaultAPI {
    let urlSession: URLSession
    
    static let sharedaApi = GitHubDefaultAPI(session: URLSession.shared)
    
    init(session: URLSession) {
        self.urlSession = session
    }
    
}

extension GitHubDefaultAPI: GitHubAPI {
    func usernameAvailable(username: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.urlEscaped)")!
        let request = URLRequest(url: url)
        return self.urlSession.rx.response(request: request)
            .map({ (pair) -> Bool in
                return pair.response.statusCode != 404
            })
            .catchErrorJustReturn(false)
    }
    
    func signUp(username: String, password: String) -> Observable<Bool> {
        let signResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signResult)
            .delay(1, scheduler: MainScheduler.instance)
    }
}

