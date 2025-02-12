//
//  AddGoodsViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/01/25.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: AddGoodsStateProtocol
protocol AddGoodsStateProtocol {

    var nameText: String { get }
}

extension AddGoodsStateProtocol {

    var isAddButtonEnabled: Bool {
        return !nameText.isEmpty
    }

    var nameSaperatorColor: UIColor {
        return nameText.isEmpty ? UIColor.cD8D8D8 : UIColor.c859EFF
    }
}

final class AddGoodsViewModel: APIStateProtocol {

    struct UIState: AddGoodsStateProtocol {

        let nameText: String
    }

    let apiStateRelay = PublishRelay<APIState>()
    let nameText = BehaviorRelay(value: "")
    let isAddButtonEnabled: Observable<Bool>
    let nameSaperatorColor: Observable<UIColor>

    init() {
        let state = nameText
            .asObservable().map { UIState(nameText: $0) }
        isAddButtonEnabled = state.map { $0.isAddButtonEnabled }
        nameSaperatorColor = state.map { $0.nameSaperatorColor }
    }

    func addGoods(selectedButtonTag: Int) {
        apiStateRelay.accept(.loading)

        let category = GoodsCategory(rawValue: selectedButtonTag)?.key ?? GoodsCategory.food.key
        let goods = Goods(name: nameText.value, category: category, id: UUID().uuidString, time: Date().toString(format: DateType.firebase_key_fulldate))

        FirebaseManager.shared.addGoods(goods: goods) { [weak self] state in
            guard let this = self else { return }

            this.apiStateRelay.accept(state)
        }
    }
}
