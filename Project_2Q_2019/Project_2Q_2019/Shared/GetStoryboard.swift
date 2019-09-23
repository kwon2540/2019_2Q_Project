//
//  GetViewControllerName.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

protocol GetStoryboard {}

extension GetStoryboard where Self: UIViewController {

    static var storyBoardName: String {
        return String(describing: Self.self)
    }

    static func getStoryBoard() -> Self {
        return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardName) as! Self
    }
}
