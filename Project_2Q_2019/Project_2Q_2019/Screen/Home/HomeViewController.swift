//
//  HomeViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/08/25.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, GetStoryboard {

    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction private func signOut(_ sender: Any) {
        FirebaseManager.shared.signOut()
        AppDelegate.shared.rootViewController.showLoginScreen()
    }

    @IBAction private func option(_ sender: Any) {
    }

    @IBAction private func read(_ sender: Any) {
    }

    @IBAction private func list(_ sender: Any) {
    }

    @IBAction private func add(_ sender: Any) {
    }

}
