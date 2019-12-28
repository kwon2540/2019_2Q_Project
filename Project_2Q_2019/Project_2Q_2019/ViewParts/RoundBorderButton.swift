//
//  RoundBorderButton.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2019/12/28.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class RoundBorderButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.c859EFF.cgColor
    }
}
