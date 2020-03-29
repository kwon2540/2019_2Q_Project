//
//  HomeViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: APIStateProtocol {

    enum sectionType: Int, CaseIterable {
        case toPurchase
        case purchased

        var title: String {
            switch self {
            case .toPurchase: return "購入予定"
            case .purchased: return "購入済み"
            }
        }
    }

    let apiStateRelay = PublishRelay<APIState>()

    var date: String = Date().toString(format: .firebase_key_date)

    var sections = sectionType.allCases.map { $0 }

    var goods: [Goods] = []

    var dateList: [String] = []

    var toPurchaseData: [Goods] = []
    var purchasedData: [Goods] = []

    var toPurchaseTotalPrice = ""
    var purchasedTotalPrice = ""

    private func updateGoodsData() {
        purchasedData.removeAll()
        toPurchaseData.removeAll()
        toPurchaseTotalPrice = ""
        purchasedTotalPrice = ""

        goods.forEach { good in
            if good.isBought {
                purchasedData.append(good)
            } else {
                toPurchaseData.append(good)
            }
        }

        calculateTotalPrice()
    }

    private func calculateTotalPrice() {
        var toPurchaseTotalPrice = 0
        toPurchaseData.forEach { good in
            let totalPrice = (Int(good.price!) ?? 0) * (Int(good.amount!) ?? 0)
            toPurchaseTotalPrice += totalPrice
        }
        self.toPurchaseTotalPrice = String(toPurchaseTotalPrice)

        var purchasedTotalPrice = 0
        purchasedData.forEach { good in
            let totalPrice = (Int(good.price!) ?? 0) * (Int(good.amount!) ?? 0)
            purchasedTotalPrice += totalPrice
        }
        self.purchasedTotalPrice = String(purchasedTotalPrice)
    }

    func loadGoodsDateListFromFirebase() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoodsDateList { [weak self] (response, state) in
            guard let this = self else { return }

            if let dateList = response?.dateList {
                this.dateList = dateList
            }

            this.apiStateRelay.accept(state)
        }
    }

    func loadGoodsFromFirebase() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoodsList(date: date) { [weak self] (response, state) in
            guard let this = self else { return }

            if let goods = response?.goods {
                this.goods = goods
            }

            this.updateGoodsData()

            this.apiStateRelay.accept(state)
        }
    }
}
