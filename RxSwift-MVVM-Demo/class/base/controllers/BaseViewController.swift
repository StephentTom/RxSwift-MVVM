//
//  BaseViewController.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/9/28.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit



class BaseViewController<VM: BaseViewModel>: UIViewController {
    // MARK: UI
    
    
    // MARK: Datasource
    lazy var viewModel: VM = {
        guard let classType = "\(VM.self)".getClass(VM.self) else { return VM() }
        
        let viewModel = classType.init()

        return viewModel
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
 
// MARK: - 子类可调用
extension BaseViewController {
    func bindToast() {
        viewModel
        .loading
        .drive(rx.isShowToast)
        .disposed(by: rx.disposeBag)
    }
}



