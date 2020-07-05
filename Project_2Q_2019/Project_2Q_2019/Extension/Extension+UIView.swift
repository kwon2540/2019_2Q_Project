//
//  Extension+UIView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/01.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import UIKit

protocol XibInstantiable { }

extension XibInstantiable where Self: UIView {

    static var xibName: String {
        return String(describing: Self.self)
    }

    static func loadXib() -> Self {
        let nib = UINib(nibName: xibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! Self
        return view
    }
}

extension UIView {

    func addAndFill(_ parent: UIView) {
        parent.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }
}

class NibWrapperView<T: UIView & XibInstantiable>: UIView {
    /// The view loaded from the nib
    var contentView: T

    required init?(coder: NSCoder) {
        contentView = T.loadXib()
        super.init(coder: coder)
        prepareContentView()
    }

    override init(frame: CGRect) {
        contentView = T.loadXib()
        super.init(frame: frame)
        prepareContentView()
    }

    private func prepareContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentView.prepareForInterfaceBuilder()
    }
}
