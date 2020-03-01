//
//  Extension+UIView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/01.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func loadXib() {
        let nib = UINib(nibName: String(describing: Self.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
