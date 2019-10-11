//
//  DetailView.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/10.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import Kingfisher


class DetailView: UIView {
    // MARK: - UI
    fileprivate lazy var headImage = UIImageView()
    fileprivate lazy var usernameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    fileprivate lazy var githubCreateAtLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    fileprivate lazy var githubUpdateAtLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    // MARK: - datasource
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailView {
    func setupUI() {
        addSubview(headImage)
        addSubview(usernameLabel)
        addSubview(githubCreateAtLabel)
        addSubview(githubUpdateAtLabel)
        
        headImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.top.equalTo(headImage)
            make.height.equalTo(30)
        }
        
        githubUpdateAtLabel.snp.makeConstraints { (make) in
            make.left.equalTo(usernameLabel)
            make.bottom.equalTo(headImage)
        }
        
        githubCreateAtLabel.snp.makeConstraints { (make) in
            make.left.equalTo(usernameLabel)
            make.bottom.equalTo(githubUpdateAtLabel.snp.top).offset(-5)
        }
    }
}

extension Reactive where Base: DetailView {
    var detailModel: Binder<DetailModel> {
        return Binder(base) { (this, model) in
            this.headImage.kf.setImage(with: URL(string: model.avatar_url))
            this.usernameLabel.text = "username: \(model.name)"
            this.githubCreateAtLabel.text = "create time: \(model.created_at)"
            this.githubUpdateAtLabel.text = "update time: \(model.updated_at)"
        }
    }
}
