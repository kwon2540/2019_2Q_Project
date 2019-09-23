//
//  LoginViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, GetStoryboard {

    @IBOutlet private weak var EmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    let viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func didTapLogin(_ sender: Any) {
    }
    
    @IBAction private func didTapRegister(_ sender: Any) {
    }
}
