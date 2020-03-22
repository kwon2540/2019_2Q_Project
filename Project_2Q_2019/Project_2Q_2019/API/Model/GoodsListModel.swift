//
//  GoodsListModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/02/08.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

struct GoodsDateListModel: Codable {
    var dateList: [String]
}

struct GoodsListModel: Codable {
    var goods: [Goods]
}

struct Goods: Codable {
    var id: String
    var name: String
    var amount: String?
    var price: String?
    var isBought: Bool
    var date: String
}
