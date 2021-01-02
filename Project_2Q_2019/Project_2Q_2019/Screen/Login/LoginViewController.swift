//
//  LoginViewController.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2021/01/02.
//  Copyright © 2021 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 4
    }
}
