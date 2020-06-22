//
//  HistoryContentViewCell.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentViewCell: UITableViewCell {

    // MARK: IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    // MARK: Bind
    func bind(viewModel: HistoryContentCellViewModel) {
        nameLabel.text = viewModel.name
        amountLabel.text = viewModel.amount
        priceLabel.text = viewModel.price
    }
}
