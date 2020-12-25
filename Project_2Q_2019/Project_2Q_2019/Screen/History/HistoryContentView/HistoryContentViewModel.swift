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
    var dateCount: DateCount

    let apiStateRelay = PublishRelay<APIState>()
    let dataDidChangedSubject: PublishSubject<Void>
    var date: Observable<String> { return dateRelay.map { $0.toDisplayDate() } }
    var sectionCount: Int { return boughtGoodsSection.count }
    var totalGoodsAmount: Observable<String> { return boughtGoods.map { String($0.count) } }

    init(dateCount: DateCount, dataDidChangedSubject: PublishSubject<Void>) {
        self.dateCount = dateCount
        self.dateRelay = BehaviorRelay(value: dateCount.date)
        self.dataDidChangedSubject = dataDidChangedSubject
    }

    func numberOfRows(in section: Int) -> Int {
        return boughtGoodsSection[section].boughtGoods.count
    }

    func sectionHeaderViewModel(for section: Int) -> HistoryContentHeaderViewModel {
        let category = boughtGoodsSection[section].category
        let boughtGoods = boughtGoodsSection[section].boughtGoods

        return HistoryContentHeaderViewModel(boughtGoods: boughtGoods, category: category)
    }

    func viewModelForRow(at indexPath: IndexPath) -> HistoryContentCellViewModel {
        let boughtGood = boughtGoodsForRow(at: indexPath)
        return HistoryContentCellViewModel(boughtGood: boughtGood)
    }

    func boughtGoodsForRow(at indexPath: IndexPath) -> BoughtGoods {
        boughtGoodsSection[indexPath.section].boughtGoods[indexPath.row]
    }

    func shouldDisplayHederAndFooterView(section: Int) -> Bool {
        !boughtGoodsSection[section].boughtGoods.isEmpty
    }

    func pieChartViewModel() -> HistoryContentGraphViewModel {
        HistoryContentGraphViewModel(boughtGoods: boughtGoods.asObservable())
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
        FirebaseManager.shared.fetchBoughtGoods(for: dateRelay.value) { (response, state) in

            if let goods = response {
                self.boughtGoods.accept(goods)
            }

            self.apiStateRelay.accept(state)
        }
    }
}
