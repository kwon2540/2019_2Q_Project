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
    @IBOutlet private weak var separator: UIView!
    
    func set(name: String) {
        nameLabel.text = name
    }
    
    func setSeparator(isShow: Bool) {
        separator.isHidden = !isShow
    }
}
