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
    let id: String
    let name: String
    let amount: String?
    let price: String?
    let isBought: Bool
    let date: String
}
