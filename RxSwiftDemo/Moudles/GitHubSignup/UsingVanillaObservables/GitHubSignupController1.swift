//
//  GitHubSignupController1ViewController.swift
//  RxSwiftDemo
//
//  Created by 孟庆岭 on 2018/11/25.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubSignupController1: UIViewController {
    
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfRepeatPassword: UITextField!
    
    @IBOutlet weak var lbUsernameTip: UILabel!
    
    @IBOutlet weak var lbPasswordTip: UILabel!
    
    @IBOutlet weak var lbRepeatPasswordTip: UILabel!
    
    @IBOutlet weak var btSignup: UIButton!
    
    @IBOutlet weak var acSigningUp: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel: GitHubSignupViewModel1 = GitHubSignupViewModel1(input: (tfUsername.rx.text.orEmpty.asObservable(), tfPassword.rx.text.orEmpty.asObservable(), tfRepeatPassword.rx.text.orEmpty.asObservable(), btSignup.rx.tap.asObservable()), dependency: (API: GitHubDefaultAPI.sharedaApi, validationService: GitHubDefaultValidationService.sharedValidationService, wireframe: DefaultWireframe.shared))
        
        viewModel.signupEnable
            .subscribe(onNext: {[weak self] (valid) in
                self?.btSignup.isEnabled = valid
                self?.btSignup.alpha = valid ? 1 : 0.5
            })
            .disposed(by: disposeBag)
        
        viewModel.validateUsername
            .bind(to: lbUsernameTip.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatePassword
            .bind(to: lbPasswordTip.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatePasswordRepeat
            .bind(to: lbRepeatPasswordTip.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.signingIn
            .bind(to: acSigningUp.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.signedIn
            .subscribe(onNext: { (signed) in
                print("User signed in \(signed)")
            })
            .disposed(by: disposeBag)
    
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

}
