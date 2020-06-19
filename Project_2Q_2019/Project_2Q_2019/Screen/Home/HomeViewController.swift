//
//  HomeViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/08/25.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var corverView: UIView!

    private let disposeBag = DisposeBag()

    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupCollectionView()
    }

    @IBAction private func signOut(_ sender: Any) {
        FirebaseManager.shared.signOut()
        AppDelegate.shared.rootViewController.showLoginScreen()
    }

    @IBAction private func menu(_ sender: Any) {
        present(MenuViewController.getStoryBoard(), animated: true)
    }

    @IBAction private func expense(_ sender: Any) {
        present(ExpenseViewController.getStoryBoard(), animated: true)
    }

    @IBAction private func history(_ sender: Any) {
        present(HistoryViewController.getStoryBoard(), animated: true)
    }

    @IBAction private func add(_ sender: Any) {
        let vc = AddGoodsViewController.getStoryBoard()
        vc.dismissed = { [weak self] in
            guard let this = self else { return }
            this.corverView.isHidden = true
        }
        vc.viewModel = AddGoodsViewModel()

        corverView.isHidden = false
        present(vc, animated: true)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(of: HomeCollectionViewCell.self)

        let cellWidth = collectionView.frame.width - 80
        let cellHeight = collectionView.frame.height

        // 상하, 좌우 inset value 설정
        let insetX = (collectionView.bounds.width - cellWidth) / 2.0
        let insetY = (collectionView.bounds.height - cellHeight) / 2.0

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 20
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)

        // 스크롤이 빠르게 감속되도록 설정
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    private func bindViewModel() {

        // Output
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }

            switch state {
            case .loading:
                break
            // 성공시 콜렉션뷰 리로드
            case .success:
                this.collectionView.reloadData()
            // 실패시 드롭다운 표시 및 에러 핸들링
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
            }
        }).disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.category.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: HomeCollectionViewCell.self, for: indexPath)
        cell.viewModel = HomeCollectionViewModel(cardType: viewModel.cardType[indexPath.item])
        cell.bindViewModel()

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)

        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }

        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
