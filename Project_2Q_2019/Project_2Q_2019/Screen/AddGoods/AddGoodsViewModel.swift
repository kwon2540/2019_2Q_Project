//
//  AddGoodsViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/01/25.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

struct AddGoodsViewModel {

    struct UIState: AddGoodsStateProtocol {

        var nameText: String
    }
    var date: String
    var dateList: [DateList] = []

    init(date: String?, dateList: [DateList]?) {
        if let date = date {
            self.date = date
        } else {
            self.date = Date().toString(format: .firebase_key_date)
        }

        if let dateList = dateList {
            self.dateList = dateList
        }
    }
}
