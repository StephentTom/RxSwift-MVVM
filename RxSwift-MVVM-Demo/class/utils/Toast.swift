//
//  Toast.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mac mini on 2019/10/9.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import SVProgressHUD

/** ⚠️: SVProgressHUD未做iOS 13.0+ 适配 因此这里使用会出现崩溃 */
class Toast {
    static let `default` = Toast()
    private init() {
        SVProgressHUD.setMinimumDismissTimeInterval(0.25)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.dark)
    }
    
    /// load
    func show(_ message: String? = nil) {
        SVProgressHUD.show(withStatus: message)
    }
    
    /// success
    func showSuccess(_ message: String? = nil) {
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    /// error
    func showError(_ message: String? = nil) {
        SVProgressHUD.showError(withStatus: message)
    }
    
    /// warn
    func showInfo(_ message: String) {
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    /// dismiss
    func dismiss() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
}
