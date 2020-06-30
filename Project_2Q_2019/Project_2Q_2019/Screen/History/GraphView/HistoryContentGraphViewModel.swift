//
//  HistoryContentGraphViewModel.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/30.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import Charts

struct HistoryContentGraphViewModel {
    private let boughtGoods: Observable<[BoughtGoods]>

    let pieChartData: Observable<PieChartData>
    let totalAmount: Observable<String>

    init(boughtGoods: Observable<[BoughtGoods]>) {
        self.boughtGoods = boughtGoods

        // Pie Chart Data Set
        let pieChartColorSet = [UIColor.cFEBA5B, UIColor.cFF7273, UIColor.c60A8E0, UIColor.cA8C953] as [NSUIColor]

        let pieChartValueSet = Observable.combineLatest(boughtGoods.map { ($0.life.totalAmount, GoodsCategory.life.title) },
                                                        boughtGoods.map { ($0.fashion.totalAmount, GoodsCategory.fashion.title) },
                                                        boughtGoods.map { ($0.hobby.totalAmount, GoodsCategory.hobby.title) },
                                                        boughtGoods.map { ($0.miscellaneous.totalAmount, GoodsCategory.miscellaneous.title) }) { [$0, $1, $2, $3] }

        pieChartData = pieChartValueSet.map { (values) -> PieChartData in
            let dataEntries = values.map { PieChartDataEntry(value: $0, label: $1) }

            let dataSet = PieChartDataSet(entries: dataEntries)
            dataSet.drawValuesEnabled = false
            dataSet.label = nil

            dataSet.colors = pieChartColorSet

            let data = PieChartData(dataSet: dataSet)
            return data
        }

        // Total Amount
        totalAmount = boughtGoods.map {"\(Int($0.totalAmount))¥" }
    }
}
