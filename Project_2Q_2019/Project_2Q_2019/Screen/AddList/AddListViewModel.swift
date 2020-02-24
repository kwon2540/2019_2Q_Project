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
    var dateList: DateList?

    init(date: String) {
        self.date = date
    }

    func loadGoodsFromFirebase() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoodsList { [weak self] (response, state) in
            guard let this = self else { return }

            // 데이트리스트에서 같은 날짜를 갖고있는 데이터 찾기
            this.dateList = response?.dateList.filter {
                $0.date == this.date
            }.first

            this.apiStateRelay.accept(state)
        }
    }

    func rowCounts() -> Int {
        return dateList?.goods.count ?? 0
    }
}
