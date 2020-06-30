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

extension Array where Element == BoughtGoods {

    var life: [Element] { filter(for: .life) }

    var fashion: [Element] { filter(for: .fashion) }

    var hobby: [Element] { filter(for: .hobby) }

    var miscellaneous: [Element] { filter(for: .miscellaneous) }

    var totalAmount: Double { reduce(0) { $0 + Double($1.price * $1.amount) } }

    private func filter(for category: GoodsCategory) -> [Element] {
        filter { $0.category == category.key }
    }
}
