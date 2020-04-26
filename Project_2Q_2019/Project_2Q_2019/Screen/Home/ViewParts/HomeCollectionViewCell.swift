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
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var topTitleView: UIView!

    private let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    private let disposeBag = DisposeBag()

    var viewModel: HomeCollectionViewModel!

    override func awakeFromNib() {
        activityIndicatorView.style = .gray

        coverView.addSubview(activityIndicatorView)
    }

    override func layoutSubviews() {
        setupLayout()
        setupTableView()
        setupTopTitleViewColor()
        setupBackgroundView()
    }

    private func setupLayout() {
        mainView.layer.cornerRadius = 25
        coverView.layer.cornerRadius = 25
        coverView.backgroundColor = UIColor.cFAFAFA
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        clipsToBounds = false

        activityIndicatorView.center = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 2) - 50)
    }

    private func setupTopTitleViewColor() {
        if let cardType = viewModel.cardType {
            topTitleView.backgroundColor = cardType.color
        }
    }

    private func setupBackgroundView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
        imageView.image = UIImage(named: "NoGoodsImage")
        imageView.contentMode = .center
        tableView.backgroundView = imageView
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: HomeTableViewCell.self)
    }

    private func activityIndicatorStart() {
        coverView.isHidden = false

        if !(activityIndicatorView.isAnimating) {
            activityIndicatorView.startAnimating()
        }
    }

    private func activityIndicatorStop() {
        coverView.isHidden = true

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
            // 성공시 인디케이터 중지 및 테이블뷰 리로드
            case .success:
                this.tableView.reloadData()
                //                this.activityIndicatorStop()
            // 실패시 드롭다운 표시 및 에러 핸들링 인디케이터 중지
            case .failed:
                this.activityIndicatorStop()
            }
        }).disposed(by: disposeBag)
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
        return 40
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: HomeTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none

        return cell
    }
}
