//
//  GraphViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/12/21.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class GraphViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(of: VerticalGraphCell.self)
    }

    @IBAction private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension GraphViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension GraphViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(of: VerticalGraphCell.self, for: indexPath)
        cell.set(graphType: .month, expenditure: "40,000", dateNumber: "3", DateCharacter: "Mar", graphHeight:  0)
        
        return cell
    }
}

extension GraphViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.height)
    }
}
