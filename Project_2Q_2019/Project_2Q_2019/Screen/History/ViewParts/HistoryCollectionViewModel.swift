//
//  HistoryCollectionViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/04/05.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class HistoryCollectionViewModel: APIStateProtocol {

    let apiStateRelay = PublishRelay<APIState>()
    let dataDidChangedSubject: PublishSubject<Void>

    var dateCount: DateCount

    var date: String {
        dateCount.date
    }

    init(dateCount: DateCount, dataDidChangedSubject: PublishSubject<Void>) {
        self.dateCount = dateCount
        self.dataDidChangedSubject = dataDidChangedSubject
    }
}
