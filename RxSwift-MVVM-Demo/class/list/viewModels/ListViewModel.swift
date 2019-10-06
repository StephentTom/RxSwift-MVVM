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
        
    }
}

extension ListViewModel: ViewModelProtocol {
    typealias Input = ListInput
    typealias Output = ListOutput
    
    func transform(input: ListViewModel.ListInput) -> ListViewModel.ListOutput {
        
//        let element = BehaviorSubject<[]>()
        
        return ListOutput()
    }
}

extension ListViewModel {
    
}

