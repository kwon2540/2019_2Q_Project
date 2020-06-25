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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topTitleImageView: UIImageView!
    @IBOutlet private weak var topTitleLabel: UILabel!

    private let disposeBag = DisposeBag()

    private var viewModel: HomeCollectionViewModel!
    
    var didSelectGoods: ((Goods) -> Void)?

    override func awakeFromNib() {
        setupTableView()
    }

    override func layoutSubviews() {
        setupLayout()
        setupTopTitleView()
    }

    private func setupLayout() {
        mainView.layer.cornerRadius = 25
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        clipsToBounds = false
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: HomeTableViewCell.self)
    }

    private func setupTopTitleView() {
        topTitleImageView.image = viewModel.category.image
        topTitleLabel.text = viewModel.category.title
    }

    private func setupBackgroundView() {
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        tableView.backgroundView = viewModel.getBackgroundImage(frame: frame)
    }
    
    func bind(viewmodel: HomeCollectionViewModel) {
        viewModel = viewmodel
    }

    func reload() {
        setupBackgroundView()
        tableView.reloadData()
    }
}

extension HomeCollectionViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectGoods?(viewModel.goods[indexPath.row])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: HomeTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.set(name: viewModel.goods[indexPath.row].name)

        return cell
    }
}
