//
//  DetailTarget.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mac mini on 2019/10/10.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Moya


enum DetailApi {
    /// 获取消息
    case detail(name: String)
}

extension DetailApi: TargetType {
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    var path: String {
        switch self {
        case let .detail(name): return "/users/\(name)"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
