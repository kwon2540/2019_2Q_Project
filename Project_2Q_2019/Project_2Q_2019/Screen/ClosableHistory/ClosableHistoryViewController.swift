//
//  ClosableHistoryViewController.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/11/08.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

class ClosableHistoryViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var shadowView: ShadowView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var bannerView: UIView!
    
    private var selectedDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupHistoryContentView()
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupUI() {
        shadowView.clipsToBounds = true
        bannerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }

    static func makeInstance(selectedDate: String) -> ClosableHistoryViewController {
        let vc = ClosableHistoryViewController.getStoryBoard()
        vc.selectedDate = selectedDate
        return vc
    }

    private func setupHistoryContentView() {
        let contentViewModel = HistoryContentViewModel(dateCount: nil, dataDidChangedSubject: PublishSubject<Void>(), date: selectedDate)
        let historyContentView = HistoryContentView.loadXib()
        historyContentView.viewModel = contentViewModel
        historyContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(historyContentView)
        NSLayoutConstraint.activate([
            historyContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            historyContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            historyContentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            historyContentView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
