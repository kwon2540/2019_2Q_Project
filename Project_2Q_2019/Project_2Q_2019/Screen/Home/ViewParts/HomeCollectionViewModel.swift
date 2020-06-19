//
//  HomeCollectionViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

struct HomeCollectionViewModel {
    
    var category: GoodsCategory

    var goods: [Goods] = []

    init(category: GoodsCategory, goods: [Goods]) {
        self.category = category
        self.goods = goods
    }
}
