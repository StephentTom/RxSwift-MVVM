//
//  BaseViewModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/1.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import NSObject_Rx


class BaseViewModel: NSObject {
    
    let loading = ActivityIndicator()
    let error = ErrorTracker()
    
    required override init() {}
}

extension BaseViewModel: HasDisposeBag { }
