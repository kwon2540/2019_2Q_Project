//
//  RegistViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController, GetStoryboard {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var verifyPasswordTextField: UITextField!
    @IBOutlet private weak var nameValidView: RoundView!
    @IBOutlet private weak var emailValidView: RoundView!
    @IBOutlet private weak var passwordValidView: RoundView!
    @IBOutlet private weak var verifyPasswordValidView: RoundView!
    @IBOutlet private weak var registerButton: RoundButton!

    private let viewModel = RegisterViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        // Input
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)

        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)

        verifyPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.verifyPasswordText)
            .disposed(by: disposeBag)

        // Output
        viewModel.isNameValid
            .bind(to: nameValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isEmailValid
            .bind(to: emailValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isPasswordValid
            .bind(to: passwordValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isVerifyPasswordValid
            .bind(to: verifyPasswordValidView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isRegisterEnabled
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    @IBAction private func didTapRegister(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return }
        ActivityIndicator.shared.start(view: self.view)
        FirebaseManager.shared.createUserAccount(email: email, password: password, name: name) { (state) in
            switch state {
            case .success:
                ActivityIndicator.shared.stop(view: self.view)
                self.dismiss(animated: true)
                AppDelegate.shared.rootViewController.showHomeScreen()
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: self.view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error)
                ActivityIndicator.shared.stop(view: self.view)
            }
        }
    }

    @IBAction private func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
