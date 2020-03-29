//
//  Extension+UICollectionView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func registerXib<T: UICollectionViewCell>(of cellClass: T.Type) {
        let className = cellClass.className
        let nib: UINib? = UINib(nibName: className, bundle: Bundle(for: cellClass))
        register(nib, forCellWithReuseIdentifier: className)
    }

    func dequeueCell<T: UICollectionViewCell>(of cellClass: T.Type, for indexPath: IndexPath) -> T {
        let className = cellClass.className
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }
}
