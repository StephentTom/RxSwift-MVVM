//
//  Rx.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/6.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import RxSwift
import RxCocoa


extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map {_ in }
    }
}
