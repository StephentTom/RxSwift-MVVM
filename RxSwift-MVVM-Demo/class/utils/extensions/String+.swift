//
//  String+.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/5.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Foundation


extension String {
    /// 命名空间创建对应类
    func getClass<T>(_ type: T.Type) -> T.Type? {
        let nameSpace = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as! String
        let className = NSClassFromString(nameSpace + "." + self) as? T.Type
        
        guard let classType = className else { return nil }
        
        return classType
    }
}
