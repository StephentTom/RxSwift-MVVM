//
//  Utils.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/8.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Foundation

struct Utils {
    /// 获取网络请求失败原因
    static func getNetworkError(_ code: Int) -> String {
        switch code {
        case NSURLErrorTimedOut:
            return "抱歉，请求超时"
        case NSURLErrorCancelled:
            return "抱歉，请求取消"
        case NSURLErrorCannotConnectToHost:
            return "抱歉，连接服务器失败"
        case NSURLErrorNotConnectedToInternet:
            return "抱歉，网络连接失败, 请检查网络"
        case NSURLErrorBadServerResponse:
            return "抱歉，服务器未响应"
        default:
            return "抱歉，请求失败"
        }
    }
}
