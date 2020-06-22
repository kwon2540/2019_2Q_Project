//
//  GoodsCategory.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/06/19.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

enum GoodsCategory: Int, CaseIterable {
    case life
    case fashion
    case hobby
    case miscellaneous

    var image: UIImage? {
        switch self {
        case .life: return UIImage(named: "Life")
        case .fashion: return UIImage(named: "Fashion")
        case .hobby: return UIImage(named: "Hobbies")
        case .miscellaneous: return UIImage(named: "Etc")
        }
    }

    var title: String {
        switch self {
        case .life: return "生活"
        case .fashion: return "ファッション"
        case .hobby: return "趣味"
        case .miscellaneous: return "その他"
        }
    }
    
    var key: String {
        switch self {
        case .life: return "life"
        case .fashion: return "fashion"
        case .hobby: return "hobby"
        case .miscellaneous: return "miscellaneous"
        }
    }
    
    var color: UIColor {
        switch self {
        case .life: return .cFEBA5B
        case .fashion: return .cFF7273
        case .hobby: return .c60A8E0
        case .miscellaneous: return .cA8C953
        }
    }
}
