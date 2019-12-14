//
//  Extension+DateTest.swift
//  Project_2Q_2019Tests
//
//  Created by JUNHYEOK KWON on 2019/12/14.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import XCTest
@testable import Project_2Q_2019

class Extension_DateTest: XCTestCase {

    func testExtension_Date() {
        let referenceDate = Date(timeIntervalSince1970: 0)
        let testDate = "1970年01月01日"
        XCTAssertEqual(referenceDate.toString(format: .jp_date), testDate)

        let testYear = "1970年"
        XCTAssertEqual(referenceDate.toString(format: .jp_year), testYear)

        let testMonth = "01月"
        XCTAssertEqual(referenceDate.toString(format: .jp_month), testMonth)

        let testDay = "01日"
        XCTAssertEqual(referenceDate.toString(format: .jp_day), testDay)

    }
}
