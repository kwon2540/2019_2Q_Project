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

    private var date: String
    private let boughtGoods: BehaviorRelay<[BoughtGoods]> = BehaviorRelay(value: [])
    private var boughtGoodsSection: [HistoryContentViewSection] {
        return GoodsCategory.allCases.map { (category) -> HistoryContentViewSection in
            let categorizedGoods = boughtGoods.value.filter { $0.category == category.key }
            let categorizedSection = HistoryContentViewSection(category: category, boughtGoods: categorizedGoods)
            return categorizedSection
        }
    }

    let apiStateRelay = PublishRelay<APIState>()
    var sectionCount: Int {
        return boughtGoodsSection.count
    }

    init(date: String) {
        self.date = date
        fetchAllBoughtGoods()
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

}

// MARK: Api Fetching
extension HistoryContentViewModel {
    //TODO: Make Api Call Here
    func fetchAllBoughtGoods() {

        apiStateRelay.accept(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let mockData: [BoughtGoods] = [
                BoughtGoods(name: "Apple", category: "life", id: "id1", boughtDate: "20200622", price: 10, amount: 5),
                BoughtGoods(name: "Banana", category: "life", id: "id12", boughtDate: "20200622", price: 5, amount: 10),
                BoughtGoods(name: "Egg", category: "life", id: "id3", boughtDate: "20200622", price: 2, amount: 15),
                BoughtGoods(name: "Shirt", category: "fashion", id: "id4", boughtDate: "20200622", price: 50, amount: 1),
                BoughtGoods(name: "Pant", category: "fashion", id: "id5", boughtDate: "20200622", price: 100, amount: 1),
                BoughtGoods(name: "PokemonCard", category: "hobby", id: "id6", boughtDate: "20200622", price: 20, amount: 5),
                BoughtGoods(name: "Guitar", category: "hobby", id: "id7", boughtDate: "20200622", price: 100, amount: 1),
                BoughtGoods(name: "Item1", category: "miscellaneous", id: "id8", boughtDate: "20200622", price: 10, amount: 2),
                BoughtGoods(name: "Item2", category: "miscellaneous", id: "id9", boughtDate: "20200622", price: 15, amount: 2)
            ]

            self.boughtGoods.accept(mockData)
            self.apiStateRelay.accept(.success)
        }
    }
}
