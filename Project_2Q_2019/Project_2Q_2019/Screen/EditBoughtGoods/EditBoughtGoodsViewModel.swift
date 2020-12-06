//
//  EditBoughtGoodsViewModel.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/11/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct EditBoughtGoodsViewModel: APIStateProtocol {

    struct UIState: EditGoodsStateProtocol {

        let nameText: String
        let amountText: String
        let priceText: String
    }

    let apiStateRelay = PublishRelay<APIState>()
    let nameText = BehaviorRelay(value: "")
    let amountText = BehaviorRelay(value: "1")
    let priceText = BehaviorRelay(value: "0")
    let isCompleteButtonEnabled: Observable<Bool>
    let nameSeparatorColor: Observable<UIColor>
    let amountSeparatorColor: Observable<UIColor>
    let priceSeparatorColor: Observable<UIColor>
    let boughtGoods: BoughtGoods
    let dateCount: DateCount

    init(boughtGoods: BoughtGoods, dateCount: DateCount) {
        self.boughtGoods = boughtGoods
        self.dateCount = dateCount

        let state = Observable.combineLatest(nameText, amountText, priceText) { UIState(nameText: $0, amountText: $1, priceText: $2) }
        isCompleteButtonEnabled = state.map { $0.isCompleteButtonEnabled }
        nameSeparatorColor = state.map { $0.saperatorColor(text: $0.nameText) }
        amountSeparatorColor = state.map { $0.saperatorColor(text: $0.amountText) }
        priceSeparatorColor = state.map { $0.saperatorColor(text: $0.priceText) }
    }

    func getSeletedCategoryButtonTag() -> Int? {
        return GoodsCategory.allCases.filter {
            $0.key == boughtGoods.category
        }.first?.rawValue
    }

    func addBoughtGoods(selectedButtonTag: Int) {
        apiStateRelay.accept(.loading)

        let category = GoodsCategory(rawValue: selectedButtonTag)?.key ?? GoodsCategory.life.key
        let amount = Int(amountText.value) ?? 1
        let price = Int(priceText.value) ?? 0

        let updatedBoughtGoods = BoughtGoods(id: boughtGoods.id,
                                             boughtDate: boughtGoods.boughtDate,
                                             year: boughtGoods.year,
                                             yearMonth: boughtGoods.yearMonth,
                                             category: category,
                                             name: nameText.value,
                                             amount: amount,
                                             price: price)

        FirebaseManager.shared.updateBoughtGoods(updatedBoughtGoods: updatedBoughtGoods) { state in

            self.apiStateRelay.accept(state)
        }
    }

    func deleteBoughtGoods() {
        FirebaseManager.shared.deleteBoughtGoods(id: boughtGoods.id) { state in

            guard case .failed(let error) = state else {
                self.updateDateCount()
                return
            }
            self.apiStateRelay.accept(.failed(error: error))
        }
    }

    func revertBoughtGoods() {
        FirebaseManager.shared.revertBoughtGoods(boughtGoods: self.boughtGoods) { (state) in

            guard case .failed(let error) = state else {
                self.updateDateCount()
                return
            }
            self.apiStateRelay.accept(.failed(error: error))
        }
    }

    func updateDateCount() {
        var dateCount = self.dateCount
        dateCount.count -= 1

        FirebaseManager.shared.updateGoodsCountForDate(dateCount: dateCount) { state in

            self.apiStateRelay.accept(state)
        }
    }
}
