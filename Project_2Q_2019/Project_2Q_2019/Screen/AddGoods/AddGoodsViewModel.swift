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

        var nameText: String
    }

    let apiStateRelay = PublishRelay<APIState>()

    let nameText = BehaviorRelay(value: "")
    let priceText = BehaviorRelay(value: "")
    let amountText = BehaviorRelay(value: "")

    let isAddButtonValid: Observable<Bool>

    var date: String
    var goodsList: [Goods] = []
    var dateList: [String] = []

    init(date: String, goods: [Goods], dateList: [String]) {
        self.date = date
        self.goodsList = goods
        self.dateList = dateList

        //  AddGoods 버튼의 Enabled 판정
        let state = nameText.asObservable().map { UIState(nameText: $0) }
        isAddButtonValid = state.map { $0.isAddButtonEnabled }
    }

    private func addGoodsDateListToFirebase() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.addGoodsDatedate(dateList: dateList) {(state) in
            self.apiStateRelay.accept(state)
        }
    }

    mutating func makeGoodsData() -> [Goods] {
        let newGoods = Goods(name: nameText.value, amount: amountText.value, price: priceText.value, isBought: false, date: Date().toString(format: .firebase_key_fulldate))
        goodsList.append(newGoods)

        return goodsList
    }

    mutating func makeGoodsDateList() {
        if !dateList.contains(date) {
            dateList.append(date)
            addGoodsDateListToFirebase()
        }
    }

    func addGoodsToFirebase(goods: [Goods]) {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.addGoods(date: date, goods: goods) { (state) in
            self.apiStateRelay.accept(state)
        }
    }
}
