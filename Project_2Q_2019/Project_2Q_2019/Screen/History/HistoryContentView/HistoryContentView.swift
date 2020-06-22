//
//  HistoryContentView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentView: UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalGoodsAmountLabelArea: UIView!
    @IBOutlet weak var totalGoodsAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
