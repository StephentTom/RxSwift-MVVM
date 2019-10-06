//
//  BaseTableController.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/9/28.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import NSObject_Rx
import EmptyDataSet_Swift


class BaseTableController<RefrshVM: RefreshViewModel>: UIViewController {
    // MARK: - UI
    lazy var tableView = UITableView(frame: CGRect.zero, style: style())
    
    
    // MARK: - Datasource
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    lazy var viewModel: RefrshVM = {
        let viewModel = RefrshVM()
        
        viewModel
        .loading
        .asDriver()
        .drive(self.isLoading)
        .disposed(by: rx.disposeBag)

        return viewModel
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindHeader()
        bindFooter()
    }
}

// MARK: - 绑定
extension BaseTableController {
    func bindHeader() {
        tableView.mj_header.rx
        .beginRefresh
        .asDriver()
        .drive(viewModel.refreshInputs.beginHeaderRefresh)
        .disposed(by: rx.disposeBag)
        
        viewModel
        .refreshOutputs
        .endHeaderRefreshRespond
        .drive(tableView.mj_header.rx.endHeaderRefresh)
        .disposed(by: rx.disposeBag)
        
        viewModel
        .error
        .mapToVoid()
        .drive(tableView.mj_header.rx.endHeaderRefresh)
        .disposed(by: rx.disposeBag)
    }
    
    func bindFooter() {
        
    }
}


// MARK: - 子类可调用、重写
extension BaseTableController {
    /// 设置tableView风格
    func style() -> UITableView.Style {
        return .plain
    }
    
    /// 开启头部刷新
    final func startHeaderRefresh() {
        tableView.mj_header.beginRefreshing()
    }
}
