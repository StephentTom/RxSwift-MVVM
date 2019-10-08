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
        .drive(isLoading)
        .disposed(by: rx.disposeBag)

        return viewModel
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindHeader()
        bindFooter()
    }
    
    // MARK: - 子类可重写
    /// 设置UI
    func setupUI() {
        
    }
    /// 设置tableView风格
    func style() -> UITableView.Style {
        return .plain
    }
}

// MARK: - 刷新控件绑定
extension BaseTableController {
    func bindHeader() {
        guard let headerControl = tableView.headerControl else { return }
        
        headerControl.rx
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
        guard let footerControl = tableView.footerControl else { return }
        
        footerControl.rx
        .beginRefresh
        .asDriver()
        .drive(viewModel.refreshInputs.beginFooterRefresh)
        .disposed(by: rx.disposeBag)
        
        viewModel
        .refreshOutputs
        .endFooterRefreshRespond
        .drive(footerControl.rx.footerState)
        .disposed(by: rx.disposeBag)
        
        viewModel
        .error
        .map { [unowned self] _ -> FooterState in
            let state: FooterState =  self.tableView.isTotalDataEmpty ? .hidden : .default
            return state
        }
        .drive(footerControl.rx.footerState)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - 子类可调用
extension BaseTableController {
    /// 开启头部刷新
    final func startHeaderRefresh() {
        tableView.headerControl?.beginRefreshing()
    }
}
