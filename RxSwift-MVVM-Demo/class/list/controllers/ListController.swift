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
import MapKit


private let kCellIdentifire = "ListCell"

class ListController: BaseTableController<ListViewModel> {
    // MARK: - UI
    
    
    // MARK: - Datasource
    private let listInput = ListViewModel.ListInput()

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        startHeaderRefresh()
    }
    
    // MARK: - 重写父类
    override func setupUI() {
        super.setupUI()
        
        tableView.headerControl = MJRefreshNormalHeader()
        tableView.footerControl = MJRefreshAutoNormalFooter()
        tableView.rowHeight = 55
        tableView.tableFooterView = UIView()
        tableView.register(ListCell.self, forCellReuseIdentifier: kCellIdentifire)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - RxDataSources
extension ListController {
    func bindData() {
        let listOutput = viewModel.transform(input: listInput)
        
        listOutput
        .list
        .drive(tableView.rx.items(cellIdentifier: kCellIdentifire, cellType: ListCell.self)){ (row, itemModel, cell) in
            cell.itemModel = itemModel
        }
        .disposed(by: rx.disposeBag)
        
        tableView.rx
        .modelSelected(ListItemModel.self)
        .asDriver()
        .drive(onNext: { [unowned self] (itemModel) in
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detail") as! DetailController
            detailVC.username = itemModel.login
            
            self.navigationController?
                .pushViewController(detailVC, animated: true)
        })
        .disposed(by: rx.disposeBag)
        
    }
}
