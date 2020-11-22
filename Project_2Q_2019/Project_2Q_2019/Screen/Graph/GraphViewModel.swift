//
//  GraphViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GraphViewModel: APIStateProtocol {

    private let boughtGoods = BehaviorRelay<[BoughtGoods]>(value: [])

    let selectedYear = BehaviorRelay<String?>(value: nil)
    let selectedMonth = BehaviorRelay<String?>(value: nil)
    var totalPriceTitle: Observable<String> {
        Observable.combineLatest(selectedYear.asObservable(), selectedMonth.asObservable()) { (year, month) -> String in
            switch self.graphType {
            case .month:
                return "\(year?.toYearUnit ?? "")の支出合計"
            case .date:
                return "\(month?.getMonthText().toNonZeroBaseWithMonthUnit ?? "")の支出合計"
            }
        }
    }

    let selectedBoughtGoods = BehaviorRelay<[[BoughtGoods]]>(value: [[]])

    var maxTotalPrice: Double {
        selectedBoughtGoods.value.map { $0.totalPrice }.max() ?? 0
    }

    var graphType: VerticalGraphCell.GraphType {
        selectedMonth.value == nil ? .month : .date
    }

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

    func boughtGoodsMonthList(year: String) -> [[BoughtGoods]] {
        guard let monthList = groupByYear[year] else { return [[]] }
        return Dictionary(grouping: monthList, by: \.yearMonth)
            .sorted { $0.0 < $1.0 }.map { $0.value }
    }

    func boughtGoodsDateList(month: String) -> [[BoughtGoods]] {
        guard let dateList = groupByYearMonth[month] else { return [[]] }
        return Dictionary(grouping: dateList, by: \.boughtDate)
            .sorted { $0.0 < $1.0 }.map { $0.value }
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

    func isSelectedMonth(_ month: String?) -> Bool {
        selectedMonth.value == month
    }

    func onTapMonth(_ month: String?) {
        let newMonth = isSelectedMonth(month) ? nil : month
        selectedMonth.accept(newMonth)
    }
}

// MARK: Api Fetching
extension GraphViewModel {

    func loadBoughtGoods() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.fetchBoughtGoods { (response, state) in

            if let goods = response {
                self.boughtGoods.accept(goods)
            }

            self.apiStateRelay.accept(state)
        }
    }
}
