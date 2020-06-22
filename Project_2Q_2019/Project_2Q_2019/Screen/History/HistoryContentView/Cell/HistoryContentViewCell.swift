//
//  HistoryContentViewCell.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HistoryContentViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
