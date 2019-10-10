//
//  DetailController.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit

class DetailController: BaseViewController {
    // MARK: - UI
    
    
    // MARK: - Datasource
    var name: String = ""
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "\(name)详情"
        
        DetailApi
        .detail(name: "RxSwift")
        .request()
        .mapJSON()
        .asObservable()
        .subscribe(onNext: { (rs) in
            print(rs)
        })
        .disposed(by: rx.disposeBag)
    }
}
