//
//  GraphMonthButton.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/07/17.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class GraphYearButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .c6889FF : .c6889FF_25
        }
    }
}

