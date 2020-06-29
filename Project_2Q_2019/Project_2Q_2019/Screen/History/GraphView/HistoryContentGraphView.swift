//
//  HistoryContentGraphView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/25.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

@IBDesignable class HistoryGraphWrapper: NibWrapperView<HistoryContentGraphView> { }
final class HistoryContentGraphView: UIView, XibInstantiable {
    
    @IBOutlet weak var graphView: PieChartView!
    
    private let disposeBag: DisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        setupPieChartView()
    }
    
    private func setupPieChartView() {
        graphView.chartDescription?.text = ""
        graphView.legend.enabled = false
        graphView.drawEntryLabelsEnabled = true
        graphView.highlightPerTapEnabled = false
        graphView.drawHoleEnabled = true
        graphView.centerText = "Apple"
    }
    
    // MARK: Bind
    func bind(viewModel: HistoryContentGraphViewModel) {
        viewModel
            .pieChartData
            .asDriver(onErrorJustReturn: PieChartData())
            .drive(onNext: set(pieChartData:))
            .disposed(by: disposeBag)
    }
    
    private func set(pieChartData: PieChartData) {
        graphView.data = pieChartData
    }
}

struct HistoryContentGraphViewModel {
    private let boughtGoods: Observable<[BoughtGoods]>
    private let pieChartColorSet: Observable<[NSUIColor]>
    private let pieChartValueSet: Observable<[Double]>
    
    let pieChartData: Observable<PieChartData>
    
    init(boughtGoods: Observable<[BoughtGoods]>) {
        func filterGoods(for category: GoodsCategory) -> Observable<Double> {
            return boughtGoods.map { (goods) -> Double in
               goods.filter { $0.category == category.key }
                    .reduce(0) { $0 + Double($1.price * $1.amount) }
            }
        }
        
        self.boughtGoods = boughtGoods
        
        let colorSet = [UIColor.cFEBA5B, UIColor.cFF7273, UIColor.c60A8E0, UIColor.cA8C953] as [NSUIColor]
        self.pieChartColorSet = Observable.from(optional: colorSet)
        
        let lifeGoodsTotal = filterGoods(for: .life)
        let fashionGoodsTotal = filterGoods(for: .fashion)
        let hobbyGoodsTotal = filterGoods(for: .hobby)
        let miscellaneousGoodsTotal = filterGoods(for: .miscellaneous)
        
        self.pieChartValueSet = Observable.combineLatest(lifeGoodsTotal, fashionGoodsTotal, hobbyGoodsTotal, miscellaneousGoodsTotal) { [$0, $1, $2, $3] }
        
        pieChartData = Observable.combineLatest(pieChartValueSet, pieChartColorSet) { (values, colors) -> PieChartData in
            let dataEntries = values.map { PieChartDataEntry(value: $0) }
            let dataSet = PieChartDataSet(entries: dataEntries)
            dataSet.colors = colors
            
            let data = PieChartData(dataSet: dataSet)
            return data
        }

    }
}


