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
    let goodsRealy = BehaviorRelay(value: "")
    let nameText = BehaviorRelay(value: "")
    let amountText = BehaviorRelay(value: "")
    let priceText = BehaviorRelay(value: "")
    let isCompleteButtonEnabled: Observable<Bool>
    let nameSaperatorColor: Observable<UIColor>
    let amountSaperatorColor: Observable<UIColor>
    let priceSaperatorColor: Observable<UIColor>
    let goods: Goods
    
    
    init(goods: Goods) {
        self.goods = goods
        
        let state = Observable.combineLatest(nameText, amountText, priceText) { UIState(nameText: $0, amountText: $1, priceText: $2) }
        isCompleteButtonEnabled = state.map { $0.isCompleteButtonEnabled }
        nameSaperatorColor = state.map { $0.saperatorColor(text: $0.nameText) }
        amountSaperatorColor = state.map { $0.saperatorColor(text: $0.amountText) }
        priceSaperatorColor = state.map { $0.saperatorColor(text: $0.priceText) }
    }
    
    func getSeletedCategoryButtonTag() -> Int? {
         return GoodsCategory.allCases.filter {
            $0.key == goods.category
        }.first?.rawValue
    }
}
