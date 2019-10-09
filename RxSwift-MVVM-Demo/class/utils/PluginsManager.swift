//
//  PluginsManager.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mac mini on 2019/10/9.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Moya


final class NetworkPlugin: PluginType {
    /// 开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    
    /// 收到请求(无论成功失败)
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("收到")
        switch result {
        case .failure(let error):
            switch error {
            case .underlying(let rsError as NSError, _):
                let errorMsg = Utils.getNetworkError(rsError.code)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.25) {
                    // ❌提示
                    print("Error Message \(errorMsg)")
                }
            default:
                print("Error Message")
            }
        default:
            break
        }
    }
}
