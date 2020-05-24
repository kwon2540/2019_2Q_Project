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
}

struct AddGoodsViewModel: APIStateProtocol {

    struct UIState: AddGoodsStateProtocol {

        let nameText: String
    }

    let apiStateRelay = PublishRelay<APIState>()
    let nameText = BehaviorRelay(value: "")
    let isAddButtonEnabled: Observable<Bool>

    init() {
        let state = nameText
            .asObservable().map { UIState(nameText: $0) }
        isAddButtonEnabled = state.map { $0.isAddButtonEnabled}
    }

}
