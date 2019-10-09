//
//  Rx.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/6.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import RxSwift
import RxCocoa


extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension Driver {
    func execute(_ closure: @autoclosure @escaping ()->Void) -> SharedSequence<SharingStrategy, E> {
        return map {
            closure()
            return $0
        }
    }
}

/** RangeReplaceableCollectionType: 使用数组的时候，总是需要对数组进行管理操作的吧，比方说增、删、改数组的内部元素。定义这些任务就是RangeReplaceableCollectionType协议存在的价值，如果我们准守了RangeReplaceableCollectionType协议，那么我们将会获得以下管理数组的方法 */
extension BehaviorRelay where Element: RangeReplaceableCollection {
    var append: AnyObserver<Element> {
        return AnyObserver { event in
            switch event {
            case .next(let element):
                self.accept(self.value + element)
            case .error(let error) :
                print("append task failure: \(error)")
            default:
                break
            }
        }
    }
}
