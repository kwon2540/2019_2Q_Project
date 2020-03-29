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

    var date: String = Date().toString(format: .firebase_key_date)

    var dateList: [String] = []

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
}
