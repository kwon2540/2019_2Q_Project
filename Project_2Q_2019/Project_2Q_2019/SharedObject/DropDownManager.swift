//
//  DropDownNotification.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/16.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

struct DropDownManager {

    static let shared = DropDownManager()

    func showDropDownNotification(view: UIView, width: CGFloat?, height: CGFloat?, type: DropDownNotification.DropDownType, message: String) {
        let dropDown = DropDownNotification()
        dropDown.text = message
        dropDown.type = type
        view.addSubview(dropDown)
    }
}

final class DropDownNotification: UIView {

    enum DropDownType {
        case notification
        case error

        var backroundColor: UIColor {
            switch self {
            case .notification:
                return .cD8D8D8
            case .error:
                return .cFF5943_85
            }
        }
    }

    private let bottomThreshold: CGFloat = 50.0
    private let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    private let dropDownLabel = UILabel()
    private lazy var aboveThreshold: CGFloat = (keyWindow?.safeAreaInsets.top ?? 0) + 10

    var dropDownWidth: CGFloat = UIScreen.main.bounds.size.width - 20.0
    var dropDownHeight: CGFloat = 50.0

    var text: String = "" {
        didSet {
            dropDownLabel.text = text
        }
    }

    var type: DropDownType = .notification {
        didSet {
            self.backgroundColor = type.backroundColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayout()
    }

    private func setLayout() {
        frame = CGRect(x: 0, y: 0, width: dropDownWidth, height: dropDownHeight)
        layer.cornerRadius = 5

        dropDownLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        dropDownLabel.textColor = .white
        dropDownLabel.numberOfLines = 0
        dropDownLabel.frame.size.width = frame.width
        dropDownLabel.textAlignment = .center
        dropDownLabel.frame.size.height = frame.height
        dropDownLabel.center = center
        addSubview(dropDownLabel)

        center.x = UIScreen.main.bounds.size.width / 2.0
        frame.origin.y -= frame.height

        startAnimation()
    }

    private func startAnimation() {
        //Drop in animation
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: { [weak self] in
            guard let self = self else { return }
            self.frame.origin.y = self.aboveThreshold
        })

        //Drop out animation
        UIView.animate(withDuration: 0.3, delay: 2.5, options: [.curveEaseInOut, .allowUserInteraction], animations: { [weak self] in
            guard let self = self else { return }
            self.frame.origin.y = -(self.dropDownHeight + 7.0)
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.removeFromSuperview()
        })
    }
}
