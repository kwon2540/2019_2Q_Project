//
//  HistoryContentHeaderView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentHeaderView: UIView {

    @IBOutlet private weak var categoryIconView: UIImageView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var contentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func bind(viewModel: HistoryContentHeaderViewModel) {
        categoryIconView.image = viewModel.categoryIcon
        totalAmountLabel.text = viewModel.totalAmount
    }

    private func setup() {
        setupContentView()
    }

    // TODO: Make Rounded Corner On Top Edges
    private func setupContentView() {

    }
}

extension HistoryContentHeaderView: XibInstantiable { }
