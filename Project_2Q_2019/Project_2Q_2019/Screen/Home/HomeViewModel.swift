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


            }
        }
        }
    }

    let apiStateRelay = PublishRelay<APIState>()

    var cardType: [CardType] = CardType.allCases.map({ $0 })
}
