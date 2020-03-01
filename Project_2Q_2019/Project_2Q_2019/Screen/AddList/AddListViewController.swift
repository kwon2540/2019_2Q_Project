//
//  AddListViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/14.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class AddListViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private let disposeBag = DisposeBag()

    var viewModel: AddListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: AddListTableViewCell.self)

        bindViewModel()
        viewModel.loadGoodsFromFirebase()
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func changeDate(_ sender: Any) {

    }

    @IBAction private func add(_ sender: Any) {
        let vc = AddGoodsViewController.getStoryBoard()
        vc.viewModel = AddGoodsViewModel(date: viewModel.date,
                                         dateList: viewModel.response?.dateList)

        vc.dismissed = { [weak self] in
            guard let this = self else { return }
            this.viewModel.loadGoodsFromFirebase()
        }

        present(vc, animated: true)
    }

    private func bindViewModel() {

        // Output
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }

            switch state {
            // 로딩 시 인디케이터 표시
            case .loading:
                ActivityIndicator.shared.start(view: view)
            // 성공시 인디케이터 중지 및 디스미스
            case .success:
                this.tableView.reloadData()
                ActivityIndicator.shared.stop(view: view)
            // 실패시 드롭다운 표시 및 에러 핸들링 인디케이터 중지
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.stop(view: view)
            }
        }).disposed(by: disposeBag)
    }
}

extension AddListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AddListTableViewHeaderView()

        switch viewModel.sections[section] {
        case .toPurchase:
            header.set(title: viewModel.sections[section].title, count: String(viewModel.toPurchaseData.count))
        case .purchased:
            header.set(title: viewModel.sections[section].title, count: String(viewModel.purchased.count))
        }

        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = AddListTableViewFooterView()

        switch viewModel.sections[section] {
        case .toPurchase:
            footer.set(totalPrice: viewModel.toPurchaseTotalPrice)
        case .purchased:
            footer.set(totalPrice: viewModel.purchasedTotalPrice)
        }

        return footer
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCounts(section: viewModel.sections[section])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: AddListTableViewCell.self, for: indexPath)
        let data: Goods

        switch viewModel.sections[indexPath.section] {
        case .toPurchase:
            data = viewModel.toPurchaseData[indexPath.row]
        case .purchased:
            data = viewModel.purchased[indexPath.row]
        }

        cell.set(name: data.name, amount: data.amount ?? "", price: data.price ?? "")

        return cell
    }
}
