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

        self.setCollectionView()
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

    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")

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
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionat section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)
        return cell
    }
}
}
