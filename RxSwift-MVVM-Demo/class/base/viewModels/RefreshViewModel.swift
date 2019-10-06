//
//  RefreshViewModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/1.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


/// 尾部刷新后显示的文本
enum FooterState {
    case `default`
    case hidden
    case noMoredData
}


class RefreshViewModel: BaseViewModel {
    var refreshInputs: RefreshInput
    var refreshOutputs: RefreshOutput
    
    /// private
    private let beginHeaderRefresh = PublishSubject<Void>()
    private let beginFooterRefresh = PublishSubject<Void>()
    private let endHeaderRefresh = PublishSubject<Void>()
    private let endFooterRefresh = PublishSubject<FooterState>()
    
    
    required init() {
        refreshInputs = RefreshInput(beginHeaderRefresh: beginHeaderRefresh.asObserver(),
                                     beginFooterRefresh: beginFooterRefresh.asObserver(),
                                     endHeaderRefresh: endHeaderRefresh.asObserver(),
                                     endFooterRefresh: endFooterRefresh.asObserver())
        
        refreshOutputs = RefreshOutput(headerRefreshRespond: beginHeaderRefresh.asDriverOnErrorJustComplete() ,
                                       footerRefreshRespond: beginFooterRefresh.asDriverOnErrorJustComplete(),
                                       endHeaderRefreshRespond: endHeaderRefresh.asDriverOnErrorJustComplete(),
                                       endFooterRefreshRespond: endFooterRefresh.asDriverOnErrorJustComplete())
    }
}

extension RefreshViewModel {
    struct RefreshInput {
        /// 开始头部下拉刷新
        var beginHeaderRefresh: AnyObserver<Void>
        /// 开始尾部上拉刷新
        var beginFooterRefresh: AnyObserver<Void>
        /// 结束头部刷新
        var endHeaderRefresh: AnyObserver<Void>
        /// 结束尾部刷新并设置尾部提示文本
        var endFooterRefresh: AnyObserver<FooterState>
    }
    
    struct RefreshOutput {
        /// 头部刷新响应
        var headerRefreshRespond: Driver<Void>
        /// 尾部刷新响应
        var footerRefreshRespond: Driver<Void>
        /// 头部刷新结束响应
        var endHeaderRefreshRespond: Driver<Void>
        /// 尾部刷新结束响应并设置尾部提示文本响应
        var endFooterRefreshRespond: Driver<FooterState>
    }
}
