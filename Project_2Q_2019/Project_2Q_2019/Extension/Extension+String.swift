//
//  Extension+String.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

extension String {
    
    var toNonZeroBase: String {
        String(Int(self) ?? 0)
    }
    
    var toNonZeroBaseWithMonthUnit: String {
        toNonZeroBase.appending("月")
    }
    }
}

extension String {

    func getYearText() -> String {
        guard self.count == 8 else { return "" }

        let startIndex = self.startIndex
        let lastIndex = self.index(self.startIndex, offsetBy: 3)

        return String(self[startIndex...lastIndex])
    }

    func getMonthText() -> String {
        guard self.count == 8 else { return "" }

        let startIndex = self.index(self.startIndex, offsetBy: 4)
        let lastIndex = self.index(self.startIndex, offsetBy: 5)

        return String(self[startIndex...lastIndex])
    }

    func getDateText() -> String {
        guard self.count == 8 else { return "" }

        let startIndex = self.index(self.startIndex, offsetBy: 6)
        let lastIndex = self.index(self.startIndex, offsetBy: 7)

        return String(self[startIndex...lastIndex])
    }

    func yyyyMMddToDate() -> Date {
        guard let year = Int(self.getYearText()),
            let month = Int(self.getMonthText()),
            let day = Int(self.getDateText()),
            let date = DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date else { return Date() }

        return date
    }

    func toDisplayDate() -> String {
        guard let year = Int(self.getYearText()),
            let month = Int(self.getMonthText()),
            let day = Int(self.getDateText()),
            let date = DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date else { return "" }

        return "\(year)/\(month)/\(day) \(date.weekday)"
    }
}
