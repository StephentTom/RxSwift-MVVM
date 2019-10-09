//
//  ListModel.swift
//  RxSwift-MVVM-Demo
//
//  Created by Mr.Hong on 2019/10/8.
//  Copyright © 2019 Mr.Hong. All rights reserved.
//

import Foundation
import KakaJSON


struct ListResultModel: Convertible {
    var total_count: Int = 0
    var incomplete_results: Int = 0
    var items: Array<ListItemModel> = []
}

struct ListItemModel: Convertible {
    var id: String = ""
    var login: String = ""
    var score: String = ""
}
