//
//  RxProperty.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/6.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh


// MARK: - 头部/尾部刷新
extension Reactive where Base: MJRefreshComponent {
    var beginRefresh: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer -> Disposable in
            
            if let control = control {
                control.refreshingBlock = {
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
        
        return ControlEvent(events: source)
    }
}

// MARK: - 刷新头部控件
extension Reactive where Base: MJRefreshHeader {
    var endHeaderRefresh: Binder<Void> {
        return Binder(base) { (header, _) in
            header.endRefreshing()
        }
    }
}

// MARK: - 刷新尾部控件
extension Reactive where Base: MJRefreshFooter {
    var footerState: Binder<FooterState> {
        return Binder(base) { (footer, state) in
            switch state {
            case .default:
                footer.isHidden = false
                footer.resetNoMoreData()
            case .hidden:
                footer.isHidden = true
                footer.resetNoMoreData()
            case .noMoredData:
                footer.isHidden = false
                footer.endRefreshingWithNoMoreData()
            }
        }
    }
}
