//
//  ReactiveExtension.swift
//  RxSwiftDemo
//
//  Created by 孟庆岭 on 2018/11/24.
//  Copyright © 2018 IT A. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIView {
    
    public var backgroundColor: Binder<UIColor?> {
        return Binder(self.base, binding: { (view, color) in
            view.backgroundColor = color
        })
    }
}
