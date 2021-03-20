//
//  HistoryViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class HistoryViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var noDataView: UIView!

    private let disposeBag = DisposeBag()

    var viewModel: HistoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.loadGoodsCountForDate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupCollectionView()
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(of: HistoryCollectionViewCell.self)

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

        // API
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }

            switch state {
            // Show indicator when loading
            case .loading:
                ActivityIndicator.shared.start(view: view)
            // Stop indicator and reload collectionview when success
            case .success:
                this.collectionView.reloadData()
                this.collectionView.scrollToItem(at: this.viewModel.currentIndex, at: .centeredHorizontally, animated: false)
                this.noDataView.isHidden = this.viewModel.hasBoughtGoods
                ActivityIndicator.shared.stop(view: view)
            // Error handling when failed
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.start(view: view)
            }
        }).disposed(by: disposeBag)

        viewModel.dataDidChangedSubject.asObservable().bind { [weak self] (_) in
            guard let this = self else { return }

            this.viewModel.loadGoodsCountForDate(isFirstLoad: false)
        }.disposed(by: disposeBag)
    }
}

extension HistoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension HistoryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: HistoryCollectionViewCell.self, for: indexPath)
        let dateCount = viewModel.dateCount(for: indexPath)

        cell.viewModel = HistoryCollectionViewModel(dateCount: dateCount, dataDidChangedSubject: viewModel.dataDidChangedSubject)
        cell.presentEditBoughtGoods = { [weak self]  vc in
            self?.presentEditBoughtGoodsViewController(vc: vc)
        }

        return cell
    }

    private func presentEditBoughtGoodsViewController (vc: EditBoughtGoodsViewController) {
        present(vc, animated: true)
    }
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout {

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

extension HistoryViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffSetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
        let cellWidth = scrollViewWidth - 80

        let currentIndex = Int(ceil(round(contentOffSetX / cellWidth)))
        viewModel.setCurrentIndex(to: currentIndex)
    }
}
