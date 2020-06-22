//
//  HistoryContentCellViewModel.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct HistoryContentCellViewModel {

    private let boughtGood: BoughtGoods

    init(boughtGood: BoughtGoods) {
        self.boughtGood = boughtGood
    }

    var name: String {
        return boughtGood.name
    }

    var amount: String {
        return "\(boughtGood.amount)個"
    }

    var price: String {
        return "\(boughtGood.price)¥"
    }
}
