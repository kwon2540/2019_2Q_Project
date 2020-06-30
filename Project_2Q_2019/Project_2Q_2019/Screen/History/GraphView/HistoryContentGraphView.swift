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

    @IBOutlet private weak var graphView: PieChartView!

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
        graphView.legend.enabled = true
        graphView.drawEntryLabelsEnabled = true
        graphView.highlightPerTapEnabled = false
        graphView.drawHoleEnabled = true
        graphView.holeRadiusPercent = 0.85
        graphView.drawEntryLabelsEnabled = false
    }

    // MARK: Bind
    func bind(viewModel: HistoryContentGraphViewModel) {
        viewModel
            .pieChartData
            .asDriver(onErrorJustReturn: PieChartData())
            .drive(onNext: set(pieChartData:))
            .disposed(by: disposeBag)

        viewModel
            .totalAmount
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: set(centerText:))
            .disposed(by: disposeBag)
    }

    private func set(pieChartData: PieChartData) {
        graphView.data = pieChartData
    }

    private func set(centerText: String) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paragraphStyle]
        let titleAttrString = NSMutableAttributedString(string: "合計", attributes: titleAttributes)

        let subTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20), .paragraphStyle: paragraphStyle]
        let subTitleAttrString = NSMutableAttributedString(string: centerText, attributes: subTitleAttributes)

        let newLine = NSAttributedString(string: "\n")
        titleAttrString.append(newLine)
        titleAttrString.append(subTitleAttrString)

        graphView.centerAttributedText = titleAttrString
    }
}
