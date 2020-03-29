//
//  HomeTableViewFooterView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HomeTableViewFooterView: UIView {

    @IBOutlet private weak var totalPriceLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }

    private func commonSetup() {
        self.loadXib()
    }

    func set(totalPrice: String) {
        totalPriceLabel.text = "¥ \(totalPrice)"
    }
}
