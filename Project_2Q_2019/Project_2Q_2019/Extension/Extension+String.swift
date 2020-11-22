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
    
    var monthCharacter: String {
        switch self.toNonZeroBase {
        case "1": return "Jan"
        case "2": return "Feb"
        case "3": return "Mar"
        case "4": return "Apr"
        case "5": return "May"
        case "6": return "Jun"
        case "7": return "Jul"
        case "8": return "Aug"
        case "9": return "Sep"
        case "10": return "Oct"
        case "11": return "Nov"
        case "12": return "Dec"
        default: return ""
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
        guard self.count == 8 || self.count == 6 else { return "" }
        
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
