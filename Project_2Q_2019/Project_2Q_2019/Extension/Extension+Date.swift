//
//  Extension+Date.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/14.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation

enum DateType {
    /// yyyy年MM月dd日
    case jp_date
    /// "yyyy年"
    case jp_year
    /// "MM月"
    case jp_month
    /// "dd日"
    case jp_day
    /// "yyyyMMdd"
    case firebase_key_date
    /// "yyyyMMddHHmmss"
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
        return formatter.shortWeekdaySymbols[weekday]
    }

    func toString(format type: DateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type.format
        return formatter.string(from: self)
    }

}
