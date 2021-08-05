//
//  EditGoodsViewModel.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: EditGoodsStateProtocol
protocol EditGoodsStateProtocol {

    var nameText: String { get }
    var amountText: String { get }
    var priceText: String { get }
}

extension EditGoodsStateProtocol {

    var isCompleteButtonEnabled: Bool {
        return !nameText.isEmpty
    }

    func saperatorColor(text: String) -> UIColor {
        return text.isEmpty ? UIColor.cD8D8D8 : UIColor.c859EFF
    }
}

struct EditGoodsViewModel: APIStateProtocol {

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
    let goods: Goods
    let dateCount: DateCount

    init(goods: Goods, dateCount: DateCount) {
        self.goods = goods
        self.dateCount = dateCount

        let state = Observable.combineLatest(nameText, amountText, priceText) { UIState(nameText: $0, amountText: $1, priceText: $2) }
        isCompleteButtonEnabled = state.map { $0.isCompleteButtonEnabled }
        nameSeparatorColor = state.map { $0.saperatorColor(text: $0.nameText) }
        amountSeparatorColor = state.map { $0.saperatorColor(text: $0.amountText) }
        priceSeparatorColor = state.map { $0.saperatorColor(text: $0.priceText) }
    }

    func getSeletedCategoryButtonTag() -> Int? {
        return GoodsCategory.allCases.filter {
            $0.key == goods.category
        }.first?.rawValue
    }

    func addBoughtGoods(selectedButtonTag: Int) {
        apiStateRelay.accept(.loading)

        let category = GoodsCategory(rawValue: selectedButtonTag)?.key ?? GoodsCategory.life.key
        let amount = Int(amountText.value) ?? 1
        let price = Int(priceText.value) ?? 0

        let boughtGoods = BoughtGoods(id: goods.id,
                                      boughtDate: Date().toString(format: .firebase_key_date),
                                      year: Date().toString(format: .year),
                                      yearMonth: Date().toString(format: .yearMonth),
                                      category: category,
                                      name: nameText.value,
                                      amount: amount,
                                      price: price)

        FirebaseManager.shared.addBoughtGoods(boughtGoods: boughtGoods) { state in

            //  成功した時
            guard case .failed(let error) = state else {
                self.deleteGoods(isNeedStartLoading: false)
                return
            }
            //  失敗した時
            self.apiStateRelay.accept(.failed(error: error))
        }
    }

    func deleteGoods(isNeedStartLoading: Bool) {
        if isNeedStartLoading {
            apiStateRelay.accept(.loading)
        }
        
        FirebaseManager.shared.deleteGoods(id: goods.id) { state in

            //  成功した時
            guard case .failed(let error) = state else {
                self.updateDateCount()
                return
            }
            //  失敗した時
            self.apiStateRelay.accept(.failed(error: error))
        }
    }

    func updateDateCount() {
        var dateCount = self.dateCount
        dateCount.count += 1

        FirebaseManager.shared.updateGoodsCountForDate(dateCount: dateCount) { state in

            self.apiStateRelay.accept(state)
        }
    }
}
