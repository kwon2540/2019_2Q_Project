//
//  HistoryContentHeaderViewModel.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

struct HistoryContentHeaderViewModel {

    private var boughtGoods: [BoughtGoods]
    private var category: GoodsCategory

    init(boughtGoods: [BoughtGoods], category: GoodsCategory) {
        self.boughtGoods = boughtGoods
        self.category = category
    }

    var totalAmount: String {
        let amount: Int = boughtGoods.reduce(0) { $0 + ($1.price * $1.amount) }
        return "\(amount)¥"
    }

    var icon: UIImage? {
        return category.image
    }
}
