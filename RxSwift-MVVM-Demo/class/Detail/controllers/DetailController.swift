//
//  DetailController.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class DetailController: BaseViewController {
    // MARK: - UI
    private lazy var detailView = DetailView()
    
    
    // MARK: - Datasource
    var username: String = ""
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "\(username)详情"
        
        setupUI()
    }
}

// MARK: - UI
extension DetailController {
    func setupUI() {
        view.addSubview(detailView)
        
        
    }
}
