//
//  RoundButton.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = UIColor.c08194B
            } else {
                self.backgroundColor = .lightGray
            }
        }
    }
}
