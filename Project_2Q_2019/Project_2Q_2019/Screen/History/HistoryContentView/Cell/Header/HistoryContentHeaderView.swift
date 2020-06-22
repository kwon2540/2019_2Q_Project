//
//  HistoryContentHeaderView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentHeaderView: UIView {

    // MARK: IBOutlet
    @IBOutlet private weak var categoryIconView: UIImageView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    
    func bind(viewModel: HistoryContentHeaderViewModel) {
        categoryIconView.image = viewModel.categoryIcon
        totalAmountLabel.text = viewModel.totalAmount
    }
}
