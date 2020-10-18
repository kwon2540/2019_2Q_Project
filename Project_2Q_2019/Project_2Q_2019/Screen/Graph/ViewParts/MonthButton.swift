//
//  MonthButton.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/10/11.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class MonthButton: UIButton {
    
    enum ButtonState {
        case selected
        case unselected
        
        var backgroundColor: UIColor {
            switch self {
            case .selected:
                return .c44CB97
            case .unselected:
                return .c44CB97_25
            }
        }
    }
    
    var yearMonth: String = ""
    
    private var month: String {
        String(yearMonth.suffix(2))
    }
    
    var buttonState: ButtonState = .unselected {
        didSet {
            self.backgroundColor = buttonState.backgroundColor
        }
    }
    
    init(yearMonth: String) {
        super.init(frame: .zero)
        self.yearMonth = yearMonth
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        backgroundColor = buttonState.backgroundColor
        setTitleColor(.white, for: .normal)
        setTitle(month.toNonZeroBaseWithMonthUnit, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

