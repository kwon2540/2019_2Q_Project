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
            $0.category == GoodsCategory.life.key
        }
        self.fashionGoods = goods.filter {
            $0.category == GoodsCategory.fashion.key
        }
        self.hobbyGoods = goods.filter {
            $0.category == GoodsCategory.hobby.key
        }
        self.miscellaneousGoods = goods.filter {
            $0.category == GoodsCategory.miscellaneous.key
        }
        if !self.lifeGoods.isEmpty {
            categorys.append(GoodsCategory.life)
        }
        if !self.fashionGoods.isEmpty {
            categorys.append(GoodsCategory.fashion)
        }
        if !self.hobbyGoods.isEmpty {
            categorys.append(GoodsCategory.hobby)
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
        case .life: return lifeGoods
        case .fashion: return fashionGoods
        case .hobby: return hobbyGoods
        case .miscellaneous: return miscellaneousGoods
        }
    }
}
