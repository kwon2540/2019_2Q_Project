//
//  GraphViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

struct GraphViewModel: APIStateProtocol {
    
    private let boughtGoods: BehaviorRelay<[BoughtGoods]> = BehaviorRelay(value: [])
    
    let selectedYear = PublishRelay<String>()
    let selectedMonth = PublishRelay<String>()
    
    private var groupByYear: [String: [BoughtGoods]] {
        Dictionary(grouping: boughtGoods.value, by: \.year)
    }
    private var groupByYearMonth: [String: [BoughtGoods]] {
        Dictionary(grouping: boughtGoods.value, by: \.yearMonth)
    }
    private var groupByYearMonthDate: [String: [BoughtGoods]] {
        Dictionary(grouping: boughtGoods.value, by: \.boughtDate)
    }
   
    private var yearMonthKeys: [String] { groupByYearMonth.map { $0.key }.sorted() }
    private var yearMonthDateKeys: [String] { groupByYearMonthDate.map { $0.key }.sorted() }
    
    let apiStateRelay = PublishRelay<APIState>()
    
    func boughtGoodsYearList(year: String) -> [BoughtGoods] {
        groupByYear[year] ?? []
    }
    
    func boughtGoodsYearMonthList(yearMonth: String) -> [BoughtGoods] {
        groupByYearMonth[yearMonth] ?? []
    }
    
    func boughtGoodsYearMonthDateList(yearMonthDate: String) -> [BoughtGoods] {
        groupByYearMonthDate[yearMonthDate] ?? []
    }
    
    func yearKeys() -> [String] {
        groupByYear.map { $0.key }.sorted()
    }
    
    func yearMonthKeys(for year: String) -> [String] {
        yearMonthKeys.filter {
            $0.starts(with: year)
        }
    }
    
    func isLastYear(year: String) -> Bool {
        yearKeys().last == year
    }
    
    func isLastMonth(month: String) -> Bool {
        yearMonthKeys(for: String(month.prefix(4))).last == month
    }
}

// MARK: Api Fetching
extension GraphViewModel {
    
    func loadBoughtGoods() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.fetchBoughtGoods{ (response, state) in

            if let goods = response {
                self.boughtGoods.accept(goods)
            }

            self.apiStateRelay.accept(state)
        }
    }
}
