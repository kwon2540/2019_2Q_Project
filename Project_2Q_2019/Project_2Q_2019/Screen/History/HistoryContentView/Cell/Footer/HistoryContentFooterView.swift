//
//  HistoryContentFooterView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentFooterView: UIView {

    @IBOutlet private weak var contentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        setupContentView()
    }

    // TODO: Make Rounded Corner On Bottom Edges
    private func setupContentView() {
    }
}

extension HistoryContentFooterView: XibInstantiable { }
