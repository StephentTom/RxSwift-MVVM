//
//  JSONToModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/8.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import KakaJSON


extension Observable {
    func mapModel<T: Convertible>(_ model: T.Type) -> Observable<T> {
        return self.map { (response) -> T in
            guard let dict = response as? Dictionary<String, Any> else {
                throw self.throwError()
            }
            
            if let error = self.responseError(dict) {
                throw error
            }
        }
    }
}

// MARK: - 错误
extension Observable {
    /// 抛异常
    fileprivate func throwError(_ code: Int = defaultErrorCode, message: String = Utils.default.getNetworkError(defaultErrorCode)) -> NSError {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.25) {
            /// 可做Toast❌提示
            print(message)
        }
        
        return NSError(domain: "Network", code: defaultErrorCode, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    /// 针对请求中的success字段作出提示
    fileprivate func responseError(_ dict: Dictionary<String, Any>) -> NSError? {
        var error: NSError?
        
        // "success": 请求成功与否字段
        if let success = dict["success"] as? Int, success == 0 {
            
        }
        return error
    }
}
