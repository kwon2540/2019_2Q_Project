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

    struct State: AccountRegisterStateProtocol {

        let nameText: String
        let emailText: String
        let passwordText: String
        let verifyPasswordText: String
    }

    let nameText = BehaviorSubject(value: "")
    let emailText = BehaviorSubject(value: "")
    let passwordText = BehaviorSubject(value: "")
    let verifyPasswordText = BehaviorSubject(value: "")

    let isNameValid: Observable<Bool>
    let isEmailValid: Observable<Bool>
    let isPasswordValid: Observable<Bool>
    let isVerifyPasswordValid: Observable<Bool>
    let isCorrespondPassword: Observable<Bool>
    let isRegisterEnabled: Observable<Bool>

    let disposeBag = DisposeBag()

    init() {
        let state = Observable
            .combineLatest(nameText, emailText, passwordText, verifyPasswordText) { State(nameText: $0, emailText: $1, passwordText: $2, verifyPasswordText: $3) }
        isNameValid = state.map { $0.isNameValid }
        isEmailValid = state.map { $0.isEmailValid }
        isPasswordValid = state.map { $0.isPasswordValid }
        isVerifyPasswordValid = state.map { $0.isVerifyPasswordValid }
        isCorrespondPassword = state.map { $0.isCorrespondPassword }
        isRegisterEnabled = state.map { $0.isRegisterEnabled }
    }
}
