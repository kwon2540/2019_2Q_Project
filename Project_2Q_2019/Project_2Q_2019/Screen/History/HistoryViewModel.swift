//
//  HistoryViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift

struct HistoryViewModel {
    let dates: [DateCount]

    init(dates: [DateCount]) {
        self.dates = dates
    }

    var numberOfItems: Int {
        dates.count
    }

    func dateCount(for indexPath: IndexPath) -> DateCount {
        dates[indexPath.row]
    }
}
