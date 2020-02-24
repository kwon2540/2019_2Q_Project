//
//  Extension+UITableView.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/02/24.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func registerXib<T: UITableViewCell>(of cellClass: T.Type) {
        let className = cellClass.className
        let nib: UINib? = UINib(nibName: className, bundle: Bundle(for: cellClass))
        register(nib, forCellReuseIdentifier: className)
    }

    func dequeueCell<T: UITableViewCell>(of cellClass: T.Type, for indexPath: IndexPath) -> T {
        let className = cellClass.className
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }
}
