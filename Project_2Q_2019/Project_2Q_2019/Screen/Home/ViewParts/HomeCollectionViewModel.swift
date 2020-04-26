//
//  HomeCollectionViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

final class HomeCollectionViewModel: APIStateProtocol {

    let apiStateRelay = PublishRelay<APIState>()

    var cardType: HomeViewModel.CardType?

    var goods: [Goods] = []

    init(cardType: HomeViewModel.CardType) {
        self.cardType = cardType

    }

    //    func loadGoodsFromFirebase() {
    //        apiStateRelay.accept(.loading)
    //        FirebaseManager.shared.loadGoodsList(date: date) { [weak self] (response, state) in
    //            guard let this = self else { return }
    //
    //            if let goods = response?.goods {
    //                this.goods = goods
    //            }
    //
    //            this.updateGoodsData()
    //
    //            this.apiStateRelay.accept(state)
    //        }
    //    }

    //    func getRowCount(section: SectionType) -> Int {
    //        switch section {
    //        case .toPurchase: return toPurchaseData.count
    //        case .purchased: return purchasedData.count
    //        }
    //    }
}
