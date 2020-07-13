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

    var viewModel: HistoryCollectionViewModel! {
        didSet {
            setupHistoryContentView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupLayout()
    }

    private func setupLayout() {
        mainView.layer.cornerRadius = 25
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)

        clipsToBounds = false
    }

    func setupHistoryContentView() {
        let contentViewModel = HistoryContentViewModel(date: viewModel.date)
        let contentView = HistoryContentView.loadXib()
        contentView.viewModel = contentViewModel
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
