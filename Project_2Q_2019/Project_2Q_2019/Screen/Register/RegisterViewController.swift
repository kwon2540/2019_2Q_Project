//
//  RegistViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, GetStoryboard {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var verifyPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction private func didTapRegister(_ sender: Any) {
    }

    @IBAction private func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
