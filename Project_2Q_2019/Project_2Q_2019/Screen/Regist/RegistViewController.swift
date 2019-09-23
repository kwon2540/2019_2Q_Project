//
//  RegistViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, GetStoryboard {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction private func didTapRegist(_ sender: Any) {
    }
}
