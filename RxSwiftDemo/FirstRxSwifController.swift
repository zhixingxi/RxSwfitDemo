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
        
        btLogin.rx.tap.subscribe(onNext: { [weak self] in
            self?.showAlert()
        }).disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }

}
