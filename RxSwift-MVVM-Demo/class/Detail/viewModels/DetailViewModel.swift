//
//  DetailViewModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/10.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class DetailViewModel: BaseViewModel {
    typealias Input = DetailInput
    typealias Output = DetailOutput
    
    struct DetailInput {
        let getDetailAction = PublishSubject<String>()
    }
    
    struct DetailOutput {
        let detail: Driver<DetailModel?>
    }
}


extension DetailViewModel: ViewModelProtocol {
    
    func transform(input: DetailViewModel.DetailInput) -> DetailViewModel.DetailOutput {
        
        let element = BehaviorRelay<DetailModel?>(value: nil)
        
        input
        .getDetailAction
        .asDriverOnErrorJustComplete()
        .flatMapLatest { [weak self] (name) -> Driver<DetailModel> in
            guard let `self` = self else { return Driver.empty() }
            
            return self.requestDetail(name)
        }
        .drive(element)
        .disposed(by: disposeBag)
        
        return DetailOutput(detail: element.asDriver())
    }
}

extension DetailViewModel {
    func requestDetail(_ name: String) -> Driver<DetailModel> {
        return DetailApi
            .detail(name: name)
            .request()
            .mapJSON()
            .debug()
            .asObservable()
            .mapModel(DetailModel.self)
            .trackActivity(loading)
            .trackError(error)
            .asDriverOnErrorJustComplete()
    }
}
