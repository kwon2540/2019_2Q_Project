//
//  GraphViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class GraphViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let hud: ProgressHUD = ProgressHUD.loadXib()
    private let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: GraphViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind()
        fetch()
    }
    
    private func setup() {
        setupCollectionView()
    }
    
    private func bind() {
        bindApiState()
    }
    
    private func fetch() {
        viewModel.loadBoughtGoods()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(of: VerticalGraphCell.self)
    }
    
    private func bindApiState() {
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self else { return }

            switch state {
            case .loading:
                this.hud.startAnimation()
            case .success:
                this.hud.stopAnimation()
                this.collectionView.reloadData()
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: this.view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                this.hud.stopAnimation()
            }
        }).disposed(by: disposeBag)
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension GraphViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
}

extension GraphViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: VerticalGraphCell.self, for: indexPath)
        cell.calculateMaxHeightIfNeeded()
        cell.set(graphType: .date, expenditure: "40,000", dateNumber: "3", DateCharacter: "Mar", heightRatio:  0)
        
        return cell
    }
}

extension GraphViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.height)
    }
}
