//
//  LogManager.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/09.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation

func apiErrorLog(logMessage: String) {
    #if DEBUG
    print("API Error Log: \(logMessage)")
    #endif
}
