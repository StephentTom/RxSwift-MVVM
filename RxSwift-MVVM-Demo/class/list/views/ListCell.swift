//
//  ListCell.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import Then


class ListCell: UITableViewCell {
    // MARK: - UI
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    // MARK: - Datasource
    var itemModel: ListItemModel? {
        didSet {
            setValue()
        }
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListCell {
    func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges
                .equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    func setValue() {
        titleLabel.text = itemModel?.login
    }
}
