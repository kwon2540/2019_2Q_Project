//
//  RegistViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {

    let nameText = BehaviorSubject(value: "")
    let emailText = BehaviorSubject(value: "")
    let passwordText = BehaviorSubject(value: "")
    let verifyPasswordText = BehaviorSubject(value: "")

    let isNameValid = BehaviorSubject(value: false)
    let isEmailValid = BehaviorSubject(value: false)
    let isPasswordValid = BehaviorSubject(value: false)
    let isVerifyPasswordValid = BehaviorSubject(value: false)
    let isSamePasswordValid = BehaviorSubject(value: false)

    let disposeBag = DisposeBag()

    init() {
        nameText.distinctUntilChanged()
            .map(checkNameValid)
            .bind(to: isNameValid)
            .disposed(by: disposeBag)

        emailText.distinctUntilChanged()
            .map(checkEmailValid)
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)

        passwordText.distinctUntilChanged()
            .map(checkPasswordValid)
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)

        verifyPasswordText.distinctUntilChanged()
            .map(checkPasswordValid)
            .bind(to: isVerifyPasswordValid)
            .disposed(by: disposeBag)
    }

    private func checkNameValid(_ name: String) -> Bool {
        return name.count > 2
    }

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
