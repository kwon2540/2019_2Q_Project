//
//  HistoryCollectionViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/04/05.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

final class HistoryCollectionViewModel: APIStateProtocol {

    let apiStateRelay = PublishRelay<APIState>()

    var date: String

    init(date: String) {
        self.date = date
    }
}
