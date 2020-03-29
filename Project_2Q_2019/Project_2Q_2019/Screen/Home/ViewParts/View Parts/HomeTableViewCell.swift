//
//  HomeTableViewCell.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    func set(name: String, amount: String, price: String) {
        nameLabel.text = name

        if !amount.isEmpty {
            amountLabel.text =  "\(String(describing: amount))個"
        }

        if !price.isEmpty {
            priceLabel.text =  "¥ \(String(describing: price))"
        }
    }
}
