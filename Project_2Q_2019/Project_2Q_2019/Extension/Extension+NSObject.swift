//
//  Extension+NSObject.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/02/24.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation

extension NSObject {

    class var className: String {
        return String(describing: self)
    }
}
