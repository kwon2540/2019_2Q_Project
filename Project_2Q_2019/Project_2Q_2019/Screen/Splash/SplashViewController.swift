//
//  SplashViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/16.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController, StoryboardInstantiable {

    override func viewDidLoad() {
        super.viewDidLoad()

        if FirebaseManager.shared.checkLogin() {
            AppDelegate.shared.rootViewController.showHomeScreen()
        } else {
            AppDelegate.shared.rootViewController.showLoginScreen()
        }
    }
}
