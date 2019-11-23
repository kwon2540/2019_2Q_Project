//
//  ActivityIndicator.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/16.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

struct ActivityIndicator {

    static let shared = ActivityIndicator()

    private let overlayView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    init() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.layer.cornerRadius = 10
        activityIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    func start(view: UIView) {
        overlayView.frame = view.frame
        activityIndicatorView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: view.frame.height / 2)

        view.addSubview(overlayView)
        view.addSubview(activityIndicatorView)

        if !(activityIndicatorView.isAnimating) {
            activityIndicatorView.startAnimating()
        }
    }

    func stop(view: UIView) {
        overlayView.removeFromSuperview()
        activityIndicatorView.removeFromSuperview()

        UIView.animate(withDuration: 0.2) {
            view.alpha = 1.0
        }
    }
}
