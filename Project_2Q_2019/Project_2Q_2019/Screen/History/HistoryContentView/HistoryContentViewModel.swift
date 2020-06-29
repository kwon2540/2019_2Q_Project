//
//  HistoryContentViewModel.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct HistoryContentViewModel: APIStateProtocol {

    struct HistoryContentViewSection {
        var category: GoodsCategory
        var boughtGoods: [BoughtGoods]
    }

    private let dateRelay: BehaviorRelay<String>
    private let boughtGoods: BehaviorRelay<[BoughtGoods]> = BehaviorRelay(value: [])
    private var boughtGoodsSection: [HistoryContentViewSection] { generateHistoryContentSections() }

    let apiStateRelay = PublishRelay<APIState>()
    var date: Observable<String> { return dateRelay.map { $0.toDisplayDate() } }
    var sectionCount: Int { return boughtGoodsSection.count }
    var totalGoodsAmount: Observable<String> { return boughtGoods.map { String($0.count) } }

    init(date: String) {
        self.dateRelay = BehaviorRelay(value: date)
    }

    func numberOfRows(in section: Int) -> Int {
        return boughtGoodsSection[section].boughtGoods.count
    }

    func sectionHeaderViewModel(for section: Int) -> HistoryContentHeaderViewModel {
        let category = boughtGoodsSection[section].category
        let boughtGoods = boughtGoodsSection[section].boughtGoods

        return HistoryContentHeaderViewModel(boughtGoods: boughtGoods, category: category)
    }

    func viewModelForRow(at indexpath: IndexPath) -> HistoryContentCellViewModel {
        let boughtGood = boughtGoodsSection[indexpath.section].boughtGoods[indexpath.row]
        return HistoryContentCellViewModel(boughtGood: boughtGood)
    }

    func shouldDisplayHederAndFooterView(section: Int) -> Bool {
        return !boughtGoodsSection[section].boughtGoods.isEmpty
    }

    func pieChartViewModel() -> HistoryContentGraphViewModel {
        return HistoryContentGraphViewModel(boughtGoods: boughtGoods.asObservable())
    }

    private func generateHistoryContentSections() -> [HistoryContentViewSection] {
        return GoodsCategory.allCases.map { (category) -> HistoryContentViewSection in
            let categorizedGoods = boughtGoods.value.filter { $0.category == category.key }
            return HistoryContentViewSection(category: category, boughtGoods: categorizedGoods)
        }
    }
}

// MARK: Api Fetching
extension HistoryContentViewModel {

    func fetchAllBoughtGoods() {

        apiStateRelay.accept(.loading)
        FirebaseManager.shared.fetchBoughtGoods { (response, state) in

            if let goods = response {
                self.boughtGoods.accept(goods)
            }

            self.apiStateRelay.accept(state)
        }
    }
}
