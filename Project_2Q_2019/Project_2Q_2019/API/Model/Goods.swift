//
//  Goods.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/02/08.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

struct Goods: Codable {
    var name: String
    var category: String
    var id: String
}


struct BoughtGoods: Codable {
    var id: String
    var boughtDate: String
    var category: String
    var name: String
    var amount: Int
    var price: Int
}
