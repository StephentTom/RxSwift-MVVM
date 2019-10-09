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
import Reachability
import RxReachability



class BaseTableController<RefrshVM: RefreshViewModel>: UIViewController {
    // MARK: - UI
    lazy var tableView = UITableView(frame: CGRect.zero, style: style())
    
    
    // MARK: - Datasource
    /// 监听当前网络状态
    let reachabilityConnection = BehaviorRelay<Reachability.Connection>(value: .wifi)
    /// 当前是否正在加载
    let isLoading = BehaviorRelay<Bool>(value: false)
    /// 数据源 nil/空 时点击view
    let didTapEmptyView = PublishSubject<Void>()
    /// 数据源 nil/空 时显示的标题
    var emptyDataSetTitle = "暂无数据"
    /// 数据源 nil/空 时显示的图片
    var emptyDataSetImage = ""
    /// 没有网络时显示的标题
    var noConnectionTitle = "请检测您的网络"
    /// 没有网络时显示的图片
    var noConnectionImage = ""
    /// 默认初始化VM
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
        bindReachability()
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

// MARK: - 刷新控件 + 网络状态绑定
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
    
    func bindReachability() {
        reachability?.rx
        .reachabilityChanged
        .map { $0.connection }
        .bind(to: reachabilityConnection)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - 子类可调用
extension BaseTableController {
    /// 开启头部刷新
    final func startHeaderRefresh() {
        tableView.headerControl?.beginRefreshing(completionBlock: { [unowned self] in
            // 设置EmptyData代理
            if self.tableView.emptyDataSetDelegate == nil || self.tableView.emptyDataSetSource == nil {
                self.tableView.emptyDataSetDelegate = self
                self.tableView.emptyDataSetSource = self
            }
        })
    }
    
    /// 显示Toast
    final func bindLoadToast() {
        viewModel
        .loading
        .drive(rx.isShowToast)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - EmptyDataSet_Swift
extension BaseTableController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return !isLoading.value
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        return didTapEmptyView.onNext(())
    }
}

extension BaseTableController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var title = ""
        switch reachabilityConnection.value {
        case .wifi, .cellular:
            title = emptyDataSetTitle
        case .none:
            title = noConnectionTitle
        }
        
        let mAttriString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        
        return mAttriString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        var icon = ""
        switch reachabilityConnection.value {
        case .wifi, .cellular:
            icon = ""
        case .none:
            icon = ""
        }
        return UIImage(named: icon)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return .clear
    }
}
