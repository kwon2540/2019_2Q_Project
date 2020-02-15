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
    var dateList: [DateList] = []

    init(date: String?, dateList: [DateList]?) {
        if let date = date {
            self.date = date
        } else {
            self.date = Date().toString(format: .firebase_key_date)
        }

        if let dateList = dateList {
            self.dateList = dateList
        }

        //  AddGoods 버튼의 Enabled 판정
        let state = nameText.asObservable().map { UIState(nameText: $0) }
        isAddButtonValid = state.map { $0.isAddButtonEnabled }
    }

    func makeGoodsData() -> [DateList] {

        let goods = Goods(name: nameText.value, amount: amountText.value, price: priceText.value, isBought: false, date: Date())

        var goodsData = dateList

        // 저장된 데이터가 없을 경우
        guard !goodsData.isEmpty else {
            return [DateList(date: date, goods: [goods])]
        }

        // 저장된 데이터가 있지만 오늘 데이터가 없을 경우
        guard let index = goodsData.firstIndex(where: { $0.date == date }) else {
            goodsData.append(DateList(date: date, goods: [goods]))
            return goodsData
        }

        // 저장된 데이터가 있고 오늘 데이터도 있을 경우
        goodsData[index].goods.append(goods)
        return goodsData
    }

    func addGoodsToFirebase(dateList: [DateList]) {
        FirebaseManager.shared.addGoods(dateList: dateList) { (state) in
            self.apiState.accept(state)
        }
    }
}
