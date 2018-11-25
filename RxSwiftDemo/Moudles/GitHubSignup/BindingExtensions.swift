//
//  BindingExtensions.swift
//  RxSwiftDemo
//
//  Created by 孟庆岭 on 2018/11/25.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension ValidtionResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .ok(let message):
            return message
        case .empty:
            return ""
        case .validing:
            return "validating"
        case .failed(let message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}


extension ValidtionResult {
    var textColor: UIColor {
        switch self {
        case .ok(_):
            return ValidationColors.okColor
        case .empty, .validing:
            return UIColor.black
        case .failed(_):
            return ValidationColors.errorColor
        }
    }
}


extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidtionResult> {
        return Binder(self.base, binding: { (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
}

