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

    var life: [Element] { return filter(for: .life) }

    var fashion: [Element] { return filter(for: .fashion) }

    var hobby: [Element] { return filter(for: .hobby) }

    var miscellaneous: [Element] { return filter(for: .miscellaneous) }

    var totalAmount: Double { return reduce(0) { $0 + Double($1.price * $1.amount) } }

    private func filter(for category: GoodsCategory) -> [Element] {
        return filter { $0.category == category.key }
    }
}
