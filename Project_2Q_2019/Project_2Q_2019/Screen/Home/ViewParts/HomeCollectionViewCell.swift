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

    private let disposeBag = DisposeBag()

    private var viewModel: HomeCollectionViewModel!

    var didSelectGoods: ((Goods) -> Void)?

    override func awakeFromNib() {
        setupTableView()
    }

    override func layoutSubviews() {
        setupLayout()
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
        tableView.separatorColor = UIColor.clear
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
        return viewModel.goods.isEmpty ? CGFloat.leastNonzeroMagnitude : 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categorys[indexPath.section]
        switch category {
        case .food:
            didSelectGoods?(viewModel.lifeGoods[indexPath.row])
        case .household:
            didSelectGoods?(viewModel.fashionGoods[indexPath.row])
        case .clothes:
            didSelectGoods?(viewModel.hobbyGoods[indexPath.row])
        case .miscellaneous:
            didSelectGoods?(viewModel.miscellaneousGoods[indexPath.row])
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = viewModel.categorys[section]
        switch category {
        case .food:
            return viewModel.lifeGoods.count
        case .household:
            return viewModel.fashionGoods.count
        case .clothes:
            return viewModel.hobbyGoods.count
        case .miscellaneous:
            return viewModel.miscellaneousGoods.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeTableViewHeader.loadXib()
        headerView.backgroundColor = UIColor.clear
        let category = viewModel.categorys[section]
        headerView.set(image: category.image, title: category.title)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: HomeTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        
        let category = viewModel.categorys[indexPath.section]
        switch category {
        case .food:
            cell.set(name: viewModel.lifeGoods[indexPath.row].name)
        case .household:
            cell.set(name: viewModel.fashionGoods[indexPath.row].name)
        case .clothes:
            cell.set(name: viewModel.hobbyGoods[indexPath.row].name)
        case .miscellaneous:
            cell.set(name: viewModel.miscellaneousGoods[indexPath.row].name)
        }
        cell.setSeparator(isShow: viewModel.getSeparatorIsShow(category: category, indexPath: indexPath.row))

        return cell
    }
}
