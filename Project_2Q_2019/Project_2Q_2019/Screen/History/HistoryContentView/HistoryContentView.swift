//
//  HistoryContentView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class HistoryContentView: UIView, XibInstantiable {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var totalGoodsAmountLabelArea: UIView!
    @IBOutlet private weak var totalGoodsAmountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var ovelayView: UIView!

    private let viewModel: HistoryContentViewModel = HistoryContentViewModel(date: "20200622")
    private let disposeBag: DisposeBag = DisposeBag()
    private let hud: ProgressHUD = ProgressHUD.loadXib()
    private let graphView: HistoryContentGraphView = HistoryContentGraphView.loadXib()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        bind()
        startFetchingBoughtGoods()
    }

    func startFetchingBoughtGoods() {
        viewModel.fetchAllBoughtGoods()
    }

    // MARK: Setup
    private func setup() {
        setupContentView()
        setupTableView()
        setupTotalGoodsAmountView()
        setupHUD()
    }

    private func setupContentView() {
        layer.cornerRadius = 25
        clipsToBounds = true
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerXib(of: HistoryContentViewCell.self)

        print(graphView.frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.tableHeaderView = graphView
    }

    private func setupTotalGoodsAmountView() {
        totalGoodsAmountLabelArea.layer.cornerRadius = 2
    }

    private func setupHUD() {
        addSubview(hud)
        hud.frame = bounds
    }

    // MARK: Bind
    private func bind() {
        bindApiState()
        bindUI()
    }

    private func bindUI() {
        viewModel
            .totalGoodsAmount
            .asDriver(onErrorJustReturn: "")
            .drive(totalGoodsAmountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .date
            .asDriver(onErrorJustReturn: "")
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func bindApiState() {
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self else { return }

            switch state {
            case .loading:
                this.hud.startAnimation()
            case .success:
                this.hud.stopAnimation()
                this.tableView.reloadData()
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: this,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                this.hud.stopAnimation()
            }
        }).disposed(by: disposeBag)
    }
}

extension HistoryContentView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: HistoryContentViewCell.self, for: indexPath)
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)

        cell.selectionStyle = .none
        cell.bind(viewModel: cellViewModel)

        return cell
    }

}

extension HistoryContentView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.shouldDisplayHederAndFooterView(section: section) else { return nil}

        let headerView = HistoryContentHeaderView.loadXib()
        let headerViewModel = viewModel.sectionHeaderViewModel(for: section)
        headerView.bind(viewModel: headerViewModel)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.shouldDisplayHederAndFooterView(section: section) else { return nil}

        let footerView = HistoryContentFooterView.loadXib()
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.shouldDisplayHederAndFooterView(section: section) else { return .leastNonzeroMagnitude }

        return 48
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard viewModel.shouldDisplayHederAndFooterView(section: section) else { return .leastNonzeroMagnitude }

        return 32
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24
    }
}
