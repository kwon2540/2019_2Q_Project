//
//  HistoryCollectionViewCell.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/04/05.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class HistoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private let disposeBag = DisposeBag()

    var viewModel: HistoryCollectionViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupHistoryContentView()
        setupLayout()
    }

    override func layoutSubviews() {
        //        setupLayout()
        //        setupTableView()
        //        setupDateText()
    }

    private func setupLayout() {
        mainView.layer.cornerRadius = 25
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)

        layer.masksToBounds = false
        clipsToBounds = false
    }

    private func setupHistoryContentView() {
        let contentView = HistoryContentView.loadXib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor)
        ])

    }

    //    private func setupTableView() {
    //        tableView.delegate = self
    //        tableView.dataSource = self
    //    }

    //    private func setupDateText() {
    //        let date = self.viewModel.date
    //        yearLabel.text = date.getYearText()
    //        dateLabel.text = "\(date.getMonthText()) \(date.getDateText())"
    //        weekLabel.text = date.yyyyMMddToDate().weekday
    //    }

    //    func bindViewModel() {
    //
    //        // Output
    //        viewModel.apiState.emit(onNext: { [weak self] (state) in
    //            guard let this = self else { return }
    //
    //            switch state {
    //            // 로딩 시 인디케이터 표시
    //            case .loading:
    //                // 성공시 인디케이터 중지 및 테이블뷰 리로드
    //                break
    //            case .success:
    //                this.tableView.reloadData()
    //            // 실패시 드롭다운 표시 및 에러 핸들링 인디케이터 중지
    //            case .failed:
    //                break
    //            }
    //        }).disposed(by: disposeBag)
    //    }
}

//extension HistoryCollectionViewCell: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
//}
//
//extension HistoryCollectionViewCell: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//}
