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

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailValidView: UIView!
    @IBOutlet private weak var passwordValidView: UIView!
    @IBOutlet private weak var loginButton: UIButton!

    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindViewModel()
    }

    private func bindViewModel() {

        // Input
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)

        // Output
        viewModel.isEmailValid
            .bind(to: emailValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isPasswordValid
            .bind(to: passwordValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    @IBAction private func didTapLogin(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FirebaseManager.shared.signIn(email: email, password: password) { (state) in
            switch state {
            case .success:
                AppDelegate.shared.rootViewController.showHomeScreen()
            case .failed(let error):
                apiErrorLog(logMessage: error)
            }
        }
    }

    @IBAction private func didTapRegister(_ sender: Any) {
        self.present(RegisterViewController.getStoryBoard(), animated: true)
    }
}
