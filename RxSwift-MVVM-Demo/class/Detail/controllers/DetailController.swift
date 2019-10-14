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
import RxOptional


class DetailController: BaseViewController<DetailViewModel> {
    // MARK: - UI
    private lazy var detailView = DetailView()
    
    
    // MARK: - Datasource
    var username: String = ""
    private let detailInput = DetailViewModel.DetailInput()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(username)详情"
        
        setupUI()
        bindViewModel()
        // 这里可调用父类Toast.(由于SVPrrogress 未适配iOS 13.0+ 会导致闪退, 这里就不做调用)
         bindToast()
    }
}

// MARK: - UI
extension DetailController {
    func setupUI() {
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(120)
        }
    }
}

// MARK: - VM
extension DetailController {
    func bindViewModel() {
        let output = viewModel.transform(input: detailInput)
        
        detailInput.getDetailAction.onNext(username)
        
        output
        .detail
        .filterNil()
        .drive(detailView.rx.detailModel)
        .disposed(by: rx.disposeBag)
    }
}
