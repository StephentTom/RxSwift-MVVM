//
//  ListViewModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ListViewModel: RefreshViewModel {
    struct ListInput {
        
    }
    
    struct ListOutput {
        var list: Driver<[ListItemModel]>
    }
}

extension ListViewModel: ViewModelProtocol {
    typealias Input = ListInput
    typealias Output = ListOutput
    
    func transform(input: ListViewModel.ListInput) -> ListViewModel.ListOutput {
        
        let element = BehaviorRelay<[ListItemModel]>(value: [])
        var page = 1
        
        // 下拉刷新
        let loadData = refreshOutputs
            .headerRefreshRespond
            .execute(page=1)
            .flatMapLatest { [unowned self] in
                return self.requestList(page: page)
            }
        
        // 上拉刷新
        let loadMore = refreshOutputs
            .footerRefreshRespond
            .execute(page+=1)
            .flatMapLatest { [unowned self] in
                return self.requestList(page: page)
            }
        
        // 处理下拉数据
        loadData
        .map { $0.items }
        .drive(element)
        .disposed(by: disposeBag)
        
        // 处理上拉数据
        loadMore
        .map { $0.items }
        .drive(element.append)
        .disposed(by: disposeBag)
        
        // 结束刷新
        loadData
        .mapToVoid()
        .drive(refreshInputs.endHeaderRefresh)
        .disposed(by: disposeBag)
        
        Driver.merge(
            loadData.map { result -> FooterState in
                let state: FooterState = result.items.count < kPageCount ? .noMoredData : .default
                return state
            },
            
            loadMore.map { result -> FooterState in
                let state: FooterState = result.items.count < kPageCount ? .noMoredData : .default
                return state
            }
        )
        .startWith(.hidden)
        .drive(refreshInputs.endFooterRefresh)
        .disposed(by: disposeBag)
        
        return ListOutput(list: element.asDriver())
    }
}

// MARK: - 请求
extension ListViewModel {
    func requestList(page: Int) -> Driver<ListResultModel> {
        return ListApi
            .messageList(page)
            .request()
            .mapJSON()
            .debug()
            .asObservable()
            .mapModel(ListResultModel.self)
            .trackActivity(loading)
            .trackError(error)
            .asDriverOnErrorJustComplete()
    }
}

