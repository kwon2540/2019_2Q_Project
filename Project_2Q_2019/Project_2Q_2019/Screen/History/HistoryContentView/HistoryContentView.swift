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

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalGoodsAmountLabelArea: UIView!
    @IBOutlet weak var totalGoodsAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: HistoryContentViewModel = HistoryContentViewModel(date: "")
    private let disposeBag: DisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        bind()
    }

    func startFetchingBoughtGoods() {
        viewModel.fetchAllBoughtGoods()
    }

    // MARK: Setup
    private func setup() {
        setupContentView()
        setupTableView()
    }

    private func setupContentView() {
        layer.cornerRadius = 25
        clipsToBounds = true
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerXib(of: HistoryContentViewCell.self)
    }

    // MARK: Bind
    private func bind() {
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self else { return }

            switch state {
            case .loading:
                ActivityIndicator.shared.start(view: this)
            case .success:
                ActivityIndicator.shared.stop(view: this)
                this.tableView.reloadData()
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: this,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.stop(view: this)
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
        let headerView = HistoryContentHeaderView.loadXib()
        let headerViewModel = viewModel.sectionHeaderViewModel(for: section)
        headerView.bind(viewModel: headerViewModel)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = HistoryContentFooterView.loadXib()
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 41
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
}
