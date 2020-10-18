//
//  VerticalGraphCell.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/07/16.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class VerticalGraphCell: UICollectionViewCell {
    
    struct GraphData {
        let graphType: GraphType
        let expenditure: String
        let dateNumber: String
        let DateCharacter: String
        let heightRatio: CGFloat
        
        static func graphData(from boughtGoods: [BoughtGoods], graphType: GraphType, maxTotalPrice: Double) -> GraphData {

            let boughtGood = boughtGoods.first
            let dateNumber = graphType == .date ? boughtGood?.boughtDate.getDateText().toNonZeroBase :
                boughtGood?.yearMonth.getMonthText().toNonZeroBase
            
            let date = boughtGood?.boughtDate.yyyyMMddToDate()
            let dateCharacter = graphType == .date ? date?.weekday : boughtGood?.yearMonth.getMonthText().monthCharacter

            return GraphData(graphType: graphType,
                             expenditure: String(boughtGoods.totalPrice),
                             dateNumber: dateNumber ?? "",
                             DateCharacter: dateCharacter ?? "",
                             heightRatio: CGFloat(boughtGoods.totalPrice / maxTotalPrice))
        }
    }
    
    enum GraphType {
        case month
        case date
    }
    
    @IBOutlet private weak var expenditureLabel: UILabel!
    @IBOutlet private weak var verticalGraphView: UIView!
    @IBOutlet private weak var dateNumberLabel: UILabel!
    @IBOutlet private weak var dateCharacterLabel: UILabel!
    @IBOutlet private weak var verticalGraphHeight: NSLayoutConstraint!
    @IBOutlet private weak var verticalGraphTop: NSLayoutConstraint!
    @IBOutlet private weak var verticalGraphBottom: NSLayoutConstraint!
    
    var maxGraphViewHeight: CGFloat = 0
    
    private func setEmptyGraphView() {
        let dashedLineBorder = CAShapeLayer()
        let graphView = verticalGraphView.bounds
        let graphViewFrame = CGRect(x: graphView.minX, y: graphView.minY, width: graphView.width, height: maxGraphViewHeight)
        dashedLineBorder.strokeColor = UIColor.lightGray.cgColor
        dashedLineBorder.lineWidth = 0.3
        dashedLineBorder.lineDashPattern = [1.5, 1.5]
        dashedLineBorder.frame = graphViewFrame
        dashedLineBorder.fillColor = nil
        dashedLineBorder.path = UIBezierPath(roundedRect: graphViewFrame, cornerRadius: graphView.width / 2).cgPath
        verticalGraphHeight.constant = maxGraphViewHeight
        verticalGraphView.layer.addSublayer(dashedLineBorder)
    }
    
    private func setGraphView(graphType: GraphType, heightRatio: CGFloat) {
        let height = heightRatio * maxGraphViewHeight
        verticalGraphHeight.constant = height
        verticalGraphView.backgroundColor = graphType == .month ? .c6889FF : .c44CB97
        let cornerRadius = height < verticalGraphView.frame.width ? height / 2 : verticalGraphView.frame.width / 2
        verticalGraphView.layer.cornerRadius = cornerRadius
    }
    
    func calculateMaxHeightIfNeeded() {
        guard maxGraphViewHeight == .zero else { return }
        maxGraphViewHeight = self.frame.height - (expenditureLabel.frame.height + dateNumberLabel.frame.height + dateCharacterLabel.frame.height + verticalGraphTop.constant + verticalGraphBottom.constant)
    }
    
    func set(graphData: GraphData) {
        expenditureLabel.text = graphData.expenditure
        dateNumberLabel.text = graphData.dateNumber
        dateCharacterLabel.text = graphData.DateCharacter
        graphData.heightRatio == .zero ? setEmptyGraphView() : setGraphView(graphType: graphData.graphType, heightRatio: graphData.heightRatio)
    }
}
