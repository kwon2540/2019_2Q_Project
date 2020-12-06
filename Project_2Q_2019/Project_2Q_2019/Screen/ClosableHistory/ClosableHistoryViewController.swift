//
//  ClosableHistoryViewController.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/11/08.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class ClosableHistoryViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var contentView: UIView!

    private var selectedDate = ""
    private var dateCount: DateCount = DateCount(date: "", count: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHistoryContentView()
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }

    static func makeInstance(selectedDate: String, dateCount: DateCount) -> ClosableHistoryViewController {
        let vc = ClosableHistoryViewController.getStoryBoard()
        vc.selectedDate = selectedDate
        return vc
    }

    private func setupHistoryContentView() {
        let contentViewModel = HistoryContentViewModel(dateCount: dateCount)
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
