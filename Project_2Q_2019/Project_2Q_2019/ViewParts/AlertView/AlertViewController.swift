//
//  AlertViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/01/11.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate: class {
    func ok()
}

class AlertViewController: UIViewController, StoryboardInstantiable {

    enum DisplayType {
        case delete

        var message: String {
            switch self {
            case .delete:
                return "削除してよろしいでしょうか？"
            }
        }

        var buttonTitle: String {
            switch self {
            case .delete:
                return "はい"
            }
        }
    }

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var okButton: RoundButton!

    weak var delegate: AlertViewControllerDelegate?

    var displayType: DisplayType = .delete

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 18
        messageLabel.text = displayType.message
        okButton.setTitle(displayType.buttonTitle, for: .normal)
    }

    @IBAction private func ok(_ sender: Any) {
        delegate?.ok()
    }

    @IBAction private func close(_ sender: Any) {
        dismiss(animated: false)
    }
}
