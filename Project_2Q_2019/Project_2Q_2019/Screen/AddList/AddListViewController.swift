//
//  AddListViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/14.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController, GetStoryboard {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func changeDate(_ sender: Any) {

    }

    @IBAction private func add(_ sender: Any) {

    }
}

extension AddListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .lightGray
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
