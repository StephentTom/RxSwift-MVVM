//
//  ListTarget.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Moya


enum ListApi {
    /// 获取消息
    case messageList(_ page: Int)
}

extension ListApi: TargetType {
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    var path: String {
        switch self {
        case .messageList: return "/search/users"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        var params = Dictionary<String, Any>()
        
        switch self {
        case let .messageList(page):
            params = ["page":page, "per_page":"10", "q":"Rxswift", "type":"Users"]
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
