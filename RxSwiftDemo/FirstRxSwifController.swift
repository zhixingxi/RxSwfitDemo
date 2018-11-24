//
//  FirstRxSwifController.swift
//  RxSwiftDemo
//
//  Created by IT A on 2018/11/23.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstRxSwifController: UIViewController {
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var lbUsernameTip: UILabel!
    
    @IBOutlet weak var lbPasswordTip: UILabel!
    
    @IBOutlet weak var btLogin: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btLogin.rx.tap.subscribe(onNext: { [weak self] in
            self?.showAlert()
        }).disposed(by: disposeBag)
        setupRxSwift2()
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    deinit {
        print("页面释放")
    }
}

// MARK: - 实现方法 1
extension FirstRxSwifController {
    
    /// 使用 DisposeBag 来管理 订阅的
    private func setupRxSwift1() {
        
        let usernameValid = tfUsername.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1)
        
        let passwordValid = tfPassword.rx.text.orEmpty
            .map { $0.count >= 6 }
            .share(replay: 1)
        
        let allValid = Observable.combineLatest(
            usernameValid,
            passwordValid)
            .map{ $0 && $1}
            .share(replay: 1)
        
        usernameValid.bind(to: lbUsernameTip.rx.isHidden)
            .disposed(by: disposeBag)
        
        usernameValid.bind(to: tfPassword.rx.isEnabled)
            .disposed(by: disposeBag)
        
        passwordValid.bind(to: lbPasswordTip.rx.isHidden)
            .disposed(by: disposeBag)
        
        allValid.bind(to: btLogin.rx.isEnabled)
            .disposed(by: disposeBag)
        
        allValid
            .map { return $0 ? UIColor.green : UIColor.gray }
            .subscribe(onNext: {[weak self] (color) in
                self?.btLogin.backgroundColor = color
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 实现方法 2
extension FirstRxSwifController {
    
    ///
    private func setupRxSwift2() {
        
        let usernameValid = tfUsername.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1)
        
        let passwordValid = tfPassword.rx.text.orEmpty
            .map { $0.count >= 6 }
            .share(replay: 1)
        
        let allValid = Observable.combineLatest(
            usernameValid,
            passwordValid)
            .map{ $0 && $1}
            .share(replay: 1)
        
        _ = usernameValid
            .takeUntil(self.rx.deallocated)
            .bind(to: lbUsernameTip.rx.isHidden)
        
        _ = usernameValid
            .takeUntil(self.rx.deallocated)
            .bind(to: tfPassword.rx.isEnabled)
        
        _ = passwordValid
            .takeUntil(self.rx.deallocated)
            .bind(to: lbPasswordTip.rx.isHidden)
        
        _ = allValid
            .takeUntil(self.rx.deallocated)
            .bind(to: btLogin.rx.isEnabled)
        
        _ = allValid
            .takeUntil(self.rx.deallocated)
            .map({ (valid) -> UIColor in
                return valid ? UIColor.green : UIColor.gray
            })
            .subscribe(onNext: { [weak self](color) in
                self?.btLogin.backgroundColor = color
                }, onError: nil, onCompleted: nil, onDisposed: {
                    print("释放")
            })
    }
    
}


