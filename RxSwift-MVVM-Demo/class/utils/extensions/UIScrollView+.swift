//
//  UIScrollView+.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/7.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import UIKit
import MJRefresh


extension UIScrollView {
    /// 头部刷新控件
    public var headerControl: MJRefreshHeader? {
        set { mj_header = newValue }
        get { return mj_header }
    }
    
    /// 尾部刷新控件
    public var footerControl: MJRefreshFooter? {
        set { mj_footer = newValue }
        get { return mj_footer }
    }
    
    /// 数据是否为空
    public var isTotalDataEmpty: Bool {
        return mj_totalDataCount() == 0
    }
}
