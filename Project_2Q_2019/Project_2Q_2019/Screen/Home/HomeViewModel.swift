//
//  HomeViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

final class HomeViewModel: APIStateProtocol {

    let apiStateRelay = PublishRelay<APIState>()

    var reloadState: APIState = .loading
    var category: [GoodsCategory] = GoodsCategory.allCases.map({ $0 })
    var goods: [Goods] = []
    var dateCounts: [DateCount] = []

    

    func getDateCount() -> DateCount {
        let today = Date().toString(format: .firebase_key_date)
        return dateCounts.filter({ $0.date == today }).first ?? DateCount(date: today, count: 0)
    }

    func observeGoodsData() {
        FirebaseManager.shared.observeGoodsData { [weak self] in
            guard let this = self else { return }
            this.loadGoods()
            this.loadGoodsCountForDate()
        }
    }

    private func loadGoods() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoods { [weak self] (response, state) in
            guard let this = self else { return }

            if let goods = response {
                this.goods = goods
            }

            this.apiStateRelay.accept(state)
            this.reloadState = state
        }
    }

    private func loadGoodsCountForDate() {
        FirebaseManager.shared.loadGoodsCountForDate { [weak self] response, _ in
            guard let this = self else { return }

            if let dateCounts = response {
                this.dateCounts = dateCounts
            }
        }
    }
}
