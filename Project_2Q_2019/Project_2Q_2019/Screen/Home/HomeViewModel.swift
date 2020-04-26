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
        case life
        case fashion
        case hobby
        case etc

        var color: UIColor {
            switch self {
            case .life: return .cFFA700
            case .fashion: return .cFF536F
            case .hobby: return .c2C7EFF
            case .etc: return .cB8B8B8
            }
        }

        var image: UIImage? {
            switch self {
            case .life: return UIImage(named: "Life")
            case .fashion: return UIImage(named: "Fashion")
            case .hobby: return UIImage(named: "Hobby")
            case .etc: return UIImage(named: "Etc")
            }
        }

        var title: String {
            switch self {
            case .life: return "生活"
            case .fashion: return "ファッション"
            case .hobby: return "趣味"
            case .etc: return "その他"
            }
        }
    }

    let apiStateRelay = PublishRelay<APIState>()

    var cardType: [CardType] = CardType.allCases.map({ $0 })
}
