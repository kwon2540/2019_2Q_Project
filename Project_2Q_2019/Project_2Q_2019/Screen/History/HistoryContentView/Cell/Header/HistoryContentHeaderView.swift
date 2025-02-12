//
//  HistoryContentHeaderView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentHeaderView: UIView, XibInstantiable {

    @IBOutlet private weak var categoryIconView: UIImageView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var totalGoodsAmountLabelArea: UIView!
    @IBOutlet private weak var totalGoodsAmountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func bind(viewModel: HistoryContentHeaderViewModel) {
        categoryIconView.image = viewModel.categoryIcon
        totalAmountLabel.text = viewModel.totalAmount
        totalGoodsAmountLabel.text = viewModel.totalGoodsAmount
    }

    private func setup() {
        setupContentView()
        setupTotalGoodsAmountView()
    }

    private func setupContentView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private func setupTotalGoodsAmountView() {
        totalGoodsAmountLabelArea.layer.cornerRadius = 2
    }
}
