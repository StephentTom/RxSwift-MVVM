//
//  BaseViewModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/1.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit


class BaseViewModel: NSObject {
    
    let loading = ActivityIndicator()
    let error = ErrorTracker()
    
    required override init() {}
}
