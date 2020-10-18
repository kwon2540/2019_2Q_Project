//
//  GraphViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class GraphViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var yearStackView: UIStackView!
    @IBOutlet private weak var monthStackView: UIStackView!
    
    private let hud: ProgressHUD = ProgressHUD.loadXib()
    private let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: GraphViewModel!
    
    var yearsButtons: [YearButton] = []
    var monthsButtons: [MonthButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind()
        fetch()
    }
    
    private func setup() {
        setupCollectionView()
    }
    
    private func bind() {
        bindApiState()
        bindUI()
    }
    
    private func fetch() {
        viewModel.loadBoughtGoods()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(of: VerticalGraphCell.self)
    }
    
    private func bindApiState() {
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }

            switch state {
            case .loading:
                this.hud.startAnimation()
            case .success:
                this.hud.stopAnimation()
                this.setupYearButtons()
                this.viewModel.selectedYear.accept(this.viewModel.yearKeys().last ?? "")
                this.collectionView.reloadData()
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                this.hud.stopAnimation()
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        
        viewModel.selectedYear.asDriver().drive(onNext: { [weak self] (year) in
            guard let this = self, let year = year else { return }
            
            this.setupMonthButtons(for: year)
            let monthList = this.viewModel.boughtGoodsMonthList(year: year)
            this.viewModel.selectedBoughtGoods.accept(monthList)
        }).disposed(by: disposeBag)
        
        viewModel.selectedMonth.asDriver().drive(onNext: { [weak self] (month) in
            guard let this = self else { return }
            if let month = month {
                let dateList = this.viewModel.boughtGoodsDateList(month: month)
                this.viewModel.selectedBoughtGoods.accept(dateList)
            } else {
                let monthList = this.viewModel.boughtGoodsMonthList(year: this.viewModel.selectedYear.value ?? "")
                this.viewModel.selectedBoughtGoods.accept(monthList)
            }
        }).disposed(by: disposeBag)
        
        viewModel.selectedBoughtGoods.asDriver().drive(onNext: { [weak self] (month) in
            guard let this = self else { return }
            
            this.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Year Button
extension GraphViewController {
    
    private func setupYearButtons() {
        yearStackView.subviews.forEach { $0.removeFromSuperview() }
        
        viewModel.yearKeys().forEach {
            let year = YearButton(year: $0)
            year.buttonState = viewModel.isLastYear(year: $0) ? .selected : .unselected
            year.addTarget(self, action: #selector(onTapYearButton), for: .touchUpInside)
            yearStackView.addArrangedSubview(year)
            yearsButtons.append(year)
        }
        
        let spacer = UIView()
        spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
        yearStackView.addArrangedSubview(spacer)
    }
    
    @objc
    func onTapYearButton(_ sender: YearButton) {
        yearsButtons.forEach {
            $0.buttonState = sender == $0 ? .selected : .unselected
        }
        
        viewModel.selectedYear.accept(sender.year)
    }
}

// MARK: Month Button
extension GraphViewController {
    
    private func setupMonthButtons(for year: String) {
        monthStackView.subviews.forEach { $0.removeFromSuperview() }
        
        viewModel.yearMonthKeys(for: year).forEach {
            let month = MonthButton(yearMonth: $0)
            month.addTarget(self, action: #selector(onTapMonthButton), for: .touchUpInside)
            monthStackView.addArrangedSubview(month)
            monthsButtons.append(month)
        }
        
        let spacer = UIView()
        spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
        monthStackView.addArrangedSubview(spacer)
    }
    
    @objc
    func onTapMonthButton(_ sender: MonthButton) {
        monthsButtons.forEach {
            $0.buttonState = sender == $0 ? .selected : .unselected
        }
        
        sender.buttonState = viewModel.isSelectedMonth(sender.yearMonth) ? .unselected : .selected
        viewModel.onTapMonth(sender.yearMonth)
    }
}

// MARK: Date Graph
extension GraphViewController {
    
}

// MARK: Collection View
extension GraphViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
}

extension GraphViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedBoughtGoods.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: VerticalGraphCell.self, for: indexPath)
        cell.calculateMaxHeightIfNeeded()
        cell.set(graphData: VerticalGraphCell.GraphData(graphType: .date,
                                             expenditure: "40,000",
                                             dateNumber: "3",
                                             DateCharacter: "Mar",
                                             heightRatio: 0.5))
        return cell
    }
}

extension GraphViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.height)
    }
}
