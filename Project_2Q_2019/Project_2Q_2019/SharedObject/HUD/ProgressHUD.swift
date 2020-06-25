//
//  HUD.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/23.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class ProgressHUD: UIView, XibInstantiable {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        activityIndicator.layer.cornerRadius = 10
    }

    func startAnimation() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    func stopAnimation() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}
