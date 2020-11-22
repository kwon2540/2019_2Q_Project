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

    var numberOfItems: Int { dates.count }

    var lastIndex: IndexPath { IndexPath(item: numberOfItems - 1, section: 0)}

    init(dates: [DateCount]) {
        self.dates = dates
    }

    func dateCount(for indexPath: IndexPath) -> DateCount {
        dates[indexPath.row]
    }
}
