//
//  HistoryContentView.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class HistoryContentView: UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalGoodsAmountLabelArea: UIView!
    @IBOutlet weak var totalGoodsAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    // MARK: Setup
    private func setup() {
        setupTableView()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerXib(of: HistoryContentViewCell.self)
    }
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
        return 20
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
}

extension HistoryContentView: XibInstantiable { }
