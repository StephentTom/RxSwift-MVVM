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


// MARK: - 模型转换
extension Observable {
    func mapModel<T: Convertible>(_ type: T.Type) -> Observable<T> {
        return self.map { (response) -> T in
            // JSON->Dictionary
            guard let dict = response as? Dictionary<String, Any> else {
                throw self.throwError()
            }
            // 解析请求成功后, 出现success == 0
            if let error = self.responseError(dict) {
                throw error
            }
            
            let model = dict.kj.model(type)
            
            return model
        }
    }
}

// MARK: - 错误
extension Observable {
    /// 抛异常
    fileprivate func throwError(code: Int = defaultErrorCode, message: String = Utils.getNetworkError(defaultErrorCode)) -> NSError {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.25) {
            /// 可做Toast❌提示
            print(message)
        }
        
        return NSError(domain: "Network", code: defaultErrorCode, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    /// 针对请求中的success字段作出提示
    fileprivate func responseError(_ dict: Dictionary<String, Any>) -> NSError? {
        var error: NSError?
        
        // "success": 请求成功与否字段(以下字段可根据服务器所提供做修改)
        if let success = dict["success"] as? Int, success == 0 {
            // "message": success == 0时, 服务器返回的错误提示
            let msg = dict["message"] as? String ?? Utils.getNetworkError(defaultErrorCode)
            
            error = self.throwError(message: msg)
        }
        return error
    }
}
