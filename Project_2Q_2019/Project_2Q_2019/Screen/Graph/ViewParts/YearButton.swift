//
//  YearButton.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/09/06.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class YearButton: UIButton {

    enum ButtonState {
        case selected
        case unselected

        var backgroundColor: UIColor {
            switch self {
            case .selected:
                return .c6889FF
            case .unselected:
                return .c6889FF_25
            }
        }
    }

    var year: String = ""

    var buttonState: ButtonState = .unselected {
        didSet {
            self.backgroundColor = buttonState.backgroundColor
        }
    }

    init(year: String) {
        super.init(frame: .zero)
        self.year = year
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        backgroundColor = buttonState.backgroundColor
        setTitleColor(.white, for: .normal)
        setTitle("\(year)年", for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 72)
        ])
    }
}
