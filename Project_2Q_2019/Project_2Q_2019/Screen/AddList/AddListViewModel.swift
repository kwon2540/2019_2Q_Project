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

    let apiStateRelay = PublishRelay<APIState>()

    var date: String
    var response: GoodsListModel?

    init(date: String) {
        self.date = date
    }

    func loadGoodsFromFirebase() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoodsList { [weak self] (response, state) in
            guard let this = self else { return }
            this.response = response
            this.apiStateRelay.accept(state)
        }
    }
}
