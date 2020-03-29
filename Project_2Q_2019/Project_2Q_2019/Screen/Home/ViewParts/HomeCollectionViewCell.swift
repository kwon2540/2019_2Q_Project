//
//  HomeCollectionViewCell.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/30.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    private let disposeBag = DisposeBag()

    var viewModel: HomeCollectionViewModel!

    override func awakeFromNib() {
        activityIndicatorView.style = .whiteLarge

        mainView.addSubview(activityIndicatorView)
    }

    override func layoutSubviews() {
        setupLayout()
        setupTableView()
        setupDateText()
    }

    private func setupLayout() {
        mainView.layer.cornerRadius = 25
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        clipsToBounds = false

        activityIndicatorView.center = CGPoint(x: mainView.frame.width / 2, y: mainView.frame.height / 2)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: HomeTableViewCell.self)
    }

    private func setupDateText() {
        let date = self.viewModel.date
        yearLabel.text = date.getYearText()
        dateLabel.text = "\(date.getMonthText()) \(date.getDateText())"
        weekLabel.text = date.yyyyMMddToDate().weekday
    }

    private func activityIndicatorStart() {

        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        if !(activityIndicatorView.isAnimating) {
            activityIndicatorView.startAnimating()
        }
    }

    private func activityIndicatorStop() {
        mainView.backgroundColor = .white
        activityIndicatorView.stopAnimating()
    }

    func bindViewModel() {

        // Output
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self else { return }

            switch state {
            // 로딩 시 인디케이터 표시
            case .loading:
                this.activityIndicatorStart()
            // 성공시 인디케이터 중지 및 디스미스
            case .success:
                this.tableView.reloadData()
                this.activityIndicatorStop()
            // 실패시 드롭다운 표시 및 에러 핸들링 인디케이터 중지
            case .failed:
                this.activityIndicatorStop()
            }
        }).disposed(by: disposeBag)
    }
}

extension HomeCollectionViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeTableViewHeaderView()

        switch viewModel.sections[section] {
        case .toPurchase:
            header.set(title: viewModel.sections[section].title, count: String(viewModel.toPurchaseData.count))
        case .purchased:
            header.set(title: viewModel.sections[section].title, count: String(viewModel.purchasedData.count))
        }

        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = HomeTableViewFooterView()

        switch viewModel.sections[section] {
        case .toPurchase:
            footer.set(totalPrice: viewModel.toPurchaseTotalPrice)
        case .purchased:
            footer.set(totalPrice: viewModel.purchasedTotalPrice)
        }

        return footer
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCount(section: viewModel.sections[section])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: HomeTableViewCell.self, for: indexPath)
        let data: Goods

        switch viewModel.sections[indexPath.section] {
        case .toPurchase:
            data = viewModel.toPurchaseData[indexPath.row]
        case .purchased:
            data = viewModel.purchasedData[indexPath.row]
        }

        cell.set(name: data.name, amount: data.amount ?? "", price: data.price ?? "")

        return cell
    }
}
