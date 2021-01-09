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

final class OldLoginViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailValidView: UIView!
    @IBOutlet private weak var passwordValidView: UIView!
    @IBOutlet private weak var loginButton: UIButton!

    private let viewModel = OldLoginViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
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

        // API
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }

            switch state {
            // Show indicator when loading
            case .loading:
                ActivityIndicator.shared.start(view: view)
            // Stop indicator and transition to Home when success
            case .success:
                ActivityIndicator.shared.stop(view: view)
                AppDelegate.shared.rootViewController.showHomeScreen()
            // Error handling when failed
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.stop(view: view)
            }
        }).disposed(by: disposeBag)
    }

    @IBAction private func login(_ sender: Any) {
        viewModel.login()
    }

    @IBAction private func register(_ sender: Any) {
        present(RegisterViewController.getStoryBoard(), animated: true)
    }
}
