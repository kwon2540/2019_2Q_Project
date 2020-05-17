//
//  ShadowView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/01/25.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class AlertView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.clipsToBounds = false
    }
}
