//
//  GoodsCategory.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/06/19.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

enum GoodsCategory: Int, CaseIterable {
    case food
    case household
    case clothes
    case miscellaneous

    var image: UIImage? {
        switch self {
        case .food: return UIImage(named: "food")
        case .household: return UIImage(named: "household")
        case .clothes: return UIImage(named: "clothes")
        case .miscellaneous: return UIImage(named: "miscellaneous")
        }
    }

    var title: String {
        switch self {
        case .food: return "食品"
        case .household: return "生活用品"
        case .clothes: return "衣類"
        case .miscellaneous: return "その他"
        }
    }

    var key: String {
        switch self {
        case .food: return "food"
        case .household: return "household"
        case .clothes: return "clothes"
        case .miscellaneous: return "miscellaneous"
        }
    }

    var color: UIColor {
        switch self {
        case .food: return .cFEBA5B
        case .household: return .cFF7273
        case .clothes: return .c60A8E0
        case .miscellaneous: return .cA8C953
        }
    }
}
