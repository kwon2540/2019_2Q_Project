//
//  HomeTableViewHeaderView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HomeTableViewHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countView: UIView!
    @IBOutlet private weak var countLabel: UILabel!

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
        self.setLayoutCornerRadius()
    }

    private func setLayoutCornerRadius() {
        countView.layer.cornerRadius = 2
        countView.clipsToBounds = true
    }

    func set(title: String, count: String) {
        titleLabel.text = title
        countLabel.text = count
    }
}
