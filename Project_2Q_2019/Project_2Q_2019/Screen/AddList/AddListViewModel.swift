//
//  AddListViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/14.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class AddListViewModel: APIStateProtocol {

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

    var sections = sectionType.allCases.map { $0 }

    var date: String
    var response: GoodsListModel?

    var toPurchaseData: [Goods] = []
    var purchasedData: [Goods] = []

    var toPurchaseTotalPrice = ""
    var purchasedTotalPrice = ""

    init(date: String) {
        self.date = date
    }

    private func updateGoodsData(_ data: DateList?) {
        purchasedData.removeAll()
        toPurchaseData.removeAll()
        toPurchaseTotalPrice = ""
        purchasedTotalPrice = ""

        data?.goods.forEach { good in
            if good.isBought {
                purchasedData.append(good)
            } else {
                toPurchaseData.append(good)
            }
        }

        var toPurchaseTotalPrice = 0
        toPurchaseData.forEach { good in
            toPurchaseTotalPrice += Int(good.price!) ?? 0
        }
        self.toPurchaseTotalPrice = String(toPurchaseTotalPrice)

        var purchasedTotalPrice = 0
        purchasedData.forEach { good in
            purchasedTotalPrice += Int(good.price!) ?? 0
        }
        self.purchasedTotalPrice = String(purchasedTotalPrice)

    }

    func loadGoodsFromFirebase() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoodsList { [weak self] (response, state) in
            guard let this = self else { return }

            this.response = response

            // 데이트리스트에서 같은 날짜를 갖고있는 데이터 찾기
            let data = response?.dateList.filter {
                $0.date == this.date
            }.first

            this.updateGoodsData(data)

            this.apiStateRelay.accept(state)
        }
    }

    func rowCounts(section: sectionType) -> Int {
        switch section {
        case .toPurchase: return toPurchaseData.count
        case .purchased: return purchasedData.count
        }
    }
}
