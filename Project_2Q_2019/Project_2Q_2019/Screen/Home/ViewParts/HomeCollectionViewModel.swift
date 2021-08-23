//
//  HomeCollectionViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/03/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

struct HomeCollectionViewModel {

    var categorys: [GoodsCategory] = []
    var goods: [Goods] = []
    var lifeGoods: [Goods] = []
    var fashionGoods: [Goods] = []
    var hobbyGoods: [Goods] = []
    var miscellaneousGoods: [Goods] = []
    

    init(goods: [Goods]) {
        self.goods = goods
        self.lifeGoods = goods.filter {
            $0.category == GoodsCategory.food.key
        }
        self.fashionGoods = goods.filter {
            $0.category == GoodsCategory.household.key
        }
        self.hobbyGoods = goods.filter {
            $0.category == GoodsCategory.clothes.key
        }
        self.miscellaneousGoods = goods.filter {
            $0.category == GoodsCategory.miscellaneous.key
        }
        if !self.lifeGoods.isEmpty {
            categorys.append(GoodsCategory.food)
        }
        if !self.fashionGoods.isEmpty {
            categorys.append(GoodsCategory.household)
        }
        if !self.hobbyGoods.isEmpty {
            categorys.append(GoodsCategory.clothes)
        }
        if !self.miscellaneousGoods.isEmpty {
            categorys.append(GoodsCategory.miscellaneous)
        }
    }

    func getBackgroundImage(frame: CGRect) -> UIImageView? {
        guard goods.isEmpty else { return nil }
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "no_goods_image")
        imageView.contentMode = .center
        return imageView
    }
    
    func getGoodsData(category: GoodsCategory) -> [Goods] {
        switch category {
        case .food: return lifeGoods
        case .household: return fashionGoods
        case .clothes: return hobbyGoods
        case .miscellaneous: return miscellaneousGoods
        }
    }
    
    func getSectionCount() -> Int {
        let count = [!lifeGoods.isEmpty,
                 !fashionGoods.isEmpty,
                 !hobbyGoods.isEmpty,
                 !miscellaneousGoods.isEmpty]
        .filter { $0 }
        .count
        
        return count
    }
    
    func getSeparatorIsShow(category: GoodsCategory, indexPath: Int) -> Bool {
        switch category {
        case .food:
            return lifeGoods.count != indexPath + 1
        case .household:
            return fashionGoods.count != indexPath + 1
        case .clothes:
            return hobbyGoods.count != indexPath + 1
        case .miscellaneous:
            return miscellaneousGoods.count != indexPath + 1
        }
    }
}
