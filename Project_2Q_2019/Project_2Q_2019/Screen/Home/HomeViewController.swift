//
//  HomeViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/08/25.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, GetStoryboard {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOut(_ sender: Any) {
        FirebaseManager.shared.signOut()
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
}
