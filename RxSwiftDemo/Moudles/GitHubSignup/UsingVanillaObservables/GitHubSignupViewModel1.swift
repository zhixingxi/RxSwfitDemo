//
//  GitHubSignupViewModel1.swift
//  RxSwiftDemo
//
//  Created by 孟庆岭 on 2018/11/25.
//  Copyright © 2018 IT A. All rights reserved.
//

import RxSwift
import RxCocoa

class GitHubSignupViewModel1 {
    let validateUsername: Observable<ValidationResult>
    
    let validatePassword: Observable<ValidationResult>
    
    let validatePasswordRepeat: Observable<ValidationResult>
    
    let signupEnable: Observable<Bool>
    
    let signedIn: Observable<Bool>

    let signingIn: Observable<Bool>
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        loginTaps: Observable<Void>
        ),
        dependency: (
            API: GitHubAPI,
            validationService: GitHubValidationService,
            wireframe: Wireframe
        )
    ) {
        let api = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        validateUsername = input.username
            .flatMapLatest({ (username) in
                return validationService.validateUsername(username: username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
            })
            .share(replay: 1)
        
        validatePassword = input.password
            .map({ password in
                return validationService.validatePassword(password: password)
            })
            .share(replay: 1)
        
        validatePasswordRepeat = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
            .share(replay: 1)
        
        let signIn = ActivityIndicator()
        self.signingIn = signIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }

        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest({ (pair) in
                return api.signUp(username: pair.username, password: pair.password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
                    .trackActivity(signIn)
            })
            .flatMapLatest({ (loggedIn) -> Observable<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    // propagate original value
                    .map { _ in
                        loggedIn
                }
            })
            .share(replay: 1)
        
        signupEnable = Observable.combineLatest(validateUsername, validatePassword, validatePasswordRepeat, signIn.asObservable()) { (username, password, repeatPassword, signIn) in
                username.isValid && password.isValid && repeatPassword.isValid && !signIn
            }.distinctUntilChanged()
            .share(replay: 1)
    }
}
