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

class ListController: BaseTableController<ListViewModel> {
    // MARK: - UI
    
    
    // MARK: - Datasource
    private let listInput = ListViewModel.ListInput()

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension ListController {
    func setupUI() {
        tableView.rowHeight = 55
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ListController {
    
}
