//
//  GoodsListModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/02/08.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

struct GoodsList: Codable {
    var goods: [Goods]
}

struct Goods: Codable {
    var name: String
    var category: String
}
