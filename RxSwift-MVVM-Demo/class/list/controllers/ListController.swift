//
//  ListController.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import MJRefresh
import RxDataSources


private let kCellIdentifire = "ListCell"

class ListController: BaseTableController<ListViewModel> {
    // MARK: - UI
    
    
    // MARK: - Datasource
    private let listInput = ListViewModel.ListInput()

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListApi
        .messageList(1)
        .request()
        .mapJSON()
        .asObservable()
        .subscribe(onNext: { (rs) in
            print("rs:", rs)
        })
        .disposed(by: rx.disposeBag)
    }
    
    // MARK: - 重写父类
    override func setupUI() {
        super.setupUI()
        
        tableView.headerControl = MJRefreshNormalHeader()
        tableView.footerControl = MJRefreshAutoNormalFooter()
        tableView.rowHeight = 55
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - RxDataSources
extension ListController {
    
}
