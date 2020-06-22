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

    let apiStateRelay = PublishRelay<APIState>()

    var reloadState: APIState = .loading
    var category: [GoodsCategory] = GoodsCategory.allCases.map({ $0 })
    var lifeGoods: [Goods] = []
    var fashionGoods: [Goods] = []
    var hobbyGoods: [Goods] = []
    var miscellaneousGoods: [Goods] = []
    
    func loadGoods() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.loadGoods() { [weak self] (response, state) in
            guard let this = self else { return }
            
            if let goods = response {
                
                this.lifeGoods = goods.filter {
                    $0.category == GoodsCategory.life.key
                }
                
                this.fashionGoods = goods.filter {
                    $0.category == GoodsCategory.fashion.key
                }
                
                this.hobbyGoods = goods.filter {
                    $0.category == GoodsCategory.hobby.key
                }
                
                this.miscellaneousGoods = goods.filter {
                    $0.category == GoodsCategory.miscellaneous.key
                }
            }
            
            this.apiStateRelay.accept(state)
            this.reloadState = state
        }
    }
    
    func getGoodsData(category: GoodsCategory) -> [Goods] {
        switch category {
        case .life: return lifeGoods
        case .fashion: return fashionGoods
        case .hobby: return hobbyGoods
        case .miscellaneous: return miscellaneousGoods
        }
    }
}
