//
//  YearButton.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/09/06.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class YearButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(title: "")
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .c6889FF : .c6889FF_25
        }
    }
    
    private func setup(title: String) {
        self.backgroundColor = .c6889FF
        self.setTitleColor(.white, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 72)
        ])
    }
}
