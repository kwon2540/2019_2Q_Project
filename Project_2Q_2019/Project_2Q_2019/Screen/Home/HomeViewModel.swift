//
//  HomeViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

final class HomeViewModel: APIStateProtocol {

    enum CardType: Int, CaseIterable {
        case a
        case b
        case c
        case d
        case e

        var color: UIColor {
            switch self {
            case .a: return .cFFA9B0
            case .b: return .cCCD1FF
            case .c: return .cFFDDA6
            case .d: return .cD8D8D8
            case .e: return .cF96E4C
            }
        }
    }

    let apiStateRelay = PublishRelay<APIState>()

    var cardType: [CardType] = CardType.allCases.map({ $0 })
}
