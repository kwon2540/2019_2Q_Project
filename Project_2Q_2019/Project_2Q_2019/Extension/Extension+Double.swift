//
//  Extension+Double.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/11/01.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

extension Double {

    var toPrice: String {
        self.commaGroupedString() + "円"
    }
    
    func commaGroupedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.groupingSeparator = ","
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
