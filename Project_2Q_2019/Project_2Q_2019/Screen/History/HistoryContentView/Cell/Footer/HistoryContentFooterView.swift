//
//  HistoryContentFooterView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentFooterView: UIView, XibInstantiable {

    @IBOutlet private weak var contentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        setupContentView()
    }

    private func setupContentView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
