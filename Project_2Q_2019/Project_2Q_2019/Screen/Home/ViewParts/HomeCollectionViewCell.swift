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

    private let disposeBag = DisposeBag()

    var viewModel: HomeCollectionViewModel!

    override func awakeFromNib() {

    }

    override func layoutSubviews() {
        setLayout()

        bindViewModel()
        viewModel.loadGoodsFromFirebase()
    }

    private func setLayout() {
        mainView.layer.cornerRadius = 25
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        clipsToBounds = false
    }

    private func bindViewModel() {

        // Output
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self else { return }

            switch state {
            // 로딩 시 인디케이터 표시
            case .loading:
                ActivityIndicator.shared.start(view: this.mainView)
            // 성공시 인디케이터 중지 및 디스미스
            case .success:
                this.bindUI()
                ActivityIndicator.shared.stop(view: this.mainView)
            // 실패시 드롭다운 표시 및 에러 핸들링 인디케이터 중지
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: this.mainView,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.stop(view: this.mainView)
            }
        }).disposed(by: disposeBag)
    }

    private func bindUI() {
    }
}
