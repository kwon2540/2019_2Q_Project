//
//  HistoryViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class HistoryViewModel: APIStateProtocol {

    private(set) var currentIndex: IndexPath = IndexPath(item: 0, section: 0)
    private var lastIndex: IndexPath { IndexPath(item: numberOfItems - 1, section: 0) }

    let apiStateRelay = PublishRelay<APIState>()
    let dataDidChangedSubject = PublishSubject<Void>()

    var dates: [DateCount] = []
    var numberOfItems: Int { dates.count }

    func dateCount(for indexPath: IndexPath) -> DateCount {
        dates[indexPath.row]
    }

    func loadGoodsCountForDate(isFirstLoad: Bool = true) {
        apiStateRelay.accept(.loading)

        FirebaseManager.shared.loadGoodsCountForDate { [weak self] response, apiState in
            guard let this = self else { return }
            if let dateCounts = response {
                this.dates = dateCounts.filter { $0.count > 0 }
            }

            if isFirstLoad {
                this.currentIndex = this.lastIndex
            }
            this.apiStateRelay.accept(apiState)
        }
    }

    func setCurrentIndex(to index: Int) {
        currentIndex = IndexPath(item: index, section: 0)
    }
}
