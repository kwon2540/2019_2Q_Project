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

    let apiStateRelay = PublishRelay<APIState>()
    let dataDidChangedSubject = PublishSubject<Void>()

    var dates: [DateCount] = []
    var numberOfItems: Int { dates.count }
    var lastIndex: IndexPath { IndexPath(item: numberOfItems - 1, section: 0)}

    func dateCount(for indexPath: IndexPath) -> DateCount {
        dates[indexPath.row]
    }

    func loadGoodsCountForDate() {
        apiStateRelay.accept(.loading)

        FirebaseManager.shared.loadGoodsCountForDate { [weak self] response, apiState in
            guard let this = self else { return }
            if let dateCounts = response {
                this.dates = dateCounts.filter { $0.count > 0 }
            }

            this.apiStateRelay.accept(apiState)
        }
    }

    // Api for the fetching date count
    // load date count here
    // Fix ClosableHistory
    // if edited reload home view
}
