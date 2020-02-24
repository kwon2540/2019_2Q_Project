//
//  AddListTableViewCell.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/02/24.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class AddListTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    func set(name: String, amount: String?, price: String?) {
        nameLabel.text = name
        amountLabel.text = amount
        priceLabel.text = price
    }
}
