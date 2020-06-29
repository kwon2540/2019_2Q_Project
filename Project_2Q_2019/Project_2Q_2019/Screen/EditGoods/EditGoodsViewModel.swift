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

final class EditGoodsViewModel: APIStateProtocol {

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

    init(goods: Goods) {
        self.goods = goods

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
                                      category: category,
                                      name: nameText.value,
                                      amount: amount,
                                      price: price)

        FirebaseManager.shared.addBoughtGoods(boughtGoods: boughtGoods) { [weak self] state in
            guard let this = self else { return }

            this.apiStateRelay.accept(state)
        }
    }

    func deleteGoods() {
        apiStateRelay.accept(.loading)

        FirebaseManager.shared.deleteGoods(id: goods.id) { [weak self] state in
            guard let this = self else { return }

            this.apiStateRelay.accept(state)
        }
    }
}
