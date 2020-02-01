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
        self.layer.cornerRadius = self.frame.height / 2
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = .c859EFF_50
            } else {
                self.backgroundColor = .c859EFF
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = .c859EFF
            } else {
                self.backgroundColor = .cD8D8D8
            }
        }
    }
}
