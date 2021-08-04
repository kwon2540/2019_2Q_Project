//
//  HomeTableViewHeader.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2021/08/04.
//  Copyright © 2021 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HomeTableViewHeader: UITableViewHeaderFooterView, XibInstantiable {
    
    @IBOutlet private weak var topTitleImageView: UIImageView!
    @IBOutlet private weak var topTitleLabel: UILabel!
    
    func set(image: UIImage?, title: String) {
        topTitleImageView.image = image
        topTitleLabel.text = title
    }
}
