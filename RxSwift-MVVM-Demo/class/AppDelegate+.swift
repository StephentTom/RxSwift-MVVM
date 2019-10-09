//
//  AppDelegate+.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Foundation
import RxNetwork



extension AppDelegate {
    /// 设置网络
    func setNetwork() {
        Network.Configuration.default.timeoutInterval = 15
        Network.Configuration.default.plugins = [NetworkPlugin()]
    }
}
