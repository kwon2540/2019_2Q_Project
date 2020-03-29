//
//  Extension+Date.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/14.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation

enum DateType {
    case jp_date
    case jp_year
    case jp_month
    case jp_day
    case firebase_key_date
    case firebase_key_fulldate

    var format: String {
        switch self {
        case .jp_date:
            return "yyyy年MM月dd日"
        case .jp_year:
            return "yyyy年"
        case .jp_month:
            return "MM月"
        case .jp_day:
            return "dd日"
        case .firebase_key_date:
            return "yyyyMMdd"
        case .firebase_key_fulldate:
            return "yyyyMMddHHmmss"
        }
    }
}

extension Date {

    var weekday: String {
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: self)
        let weekday = component - 1
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja")
        return formatter.weekdaySymbols[weekday]
    }

    func toString(format type: DateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type.format
        return formatter.string(from: self)
    }

}
