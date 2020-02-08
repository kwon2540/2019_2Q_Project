//
//  HomeCollectionViewCell.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/30.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var mainView: UIView!

    override func awakeFromNib() {
        self.setLayout()
    }

    private func setLayout() {
        self.mainView.layer.cornerRadius = 25
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.clipsToBounds = false
    }
}
