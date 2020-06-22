//
//  Extension+UIView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/01.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import UIKit

protocol XibInstantiable { }

extension XibInstantiable where Self: UIView {
    static var xibName: String {
        return String(describing: Self.self)
    }

    static func loadXib() -> Self {
        let nib = UINib(nibName: xibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! Self
        return view
    }
}
