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

// MARK: AccountRegisterStateProtocol
protocol AccountRegisterStateProtocol {

    var nameText: String { get }
    var emailText: String { get }
    var passwordText: String { get }
    var verifyPasswordText: String { get }
}

extension AccountRegisterStateProtocol {

    var isNameValid: Bool {
        return nameText.count > 2
    }

    var isEmailValid: Bool {
        return emailText.contains("@") && emailText.contains(".")
    }

    var isPasswordValid: Bool {
        return passwordText.count > 5
    }

    var isVerifyPasswordValid: Bool {
        return verifyPasswordText.count > 5
    }

    var isCorrespondPassword: Bool {
        return passwordText == verifyPasswordText
    }

    var isRegisterEnabled: Bool {
        return isNameValid && isEmailValid && isPasswordValid && isCorrespondPassword && isVerifyPasswordValid
    }
}

struct RegisterViewModel: APIStateProtocol {

    struct UIState: AccountRegisterStateProtocol {

        let nameText: String
        let emailText: String
        let passwordText: String
        let verifyPasswordText: String
    }

    let apiStateRelay = PublishRelay<APIState>()

    let nameText = BehaviorRelay(value: "")
    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")
    let verifyPasswordText = BehaviorRelay(value: "")

    let isNameValid: Observable<Bool>
    let isEmailValid: Observable<Bool>
    let isPasswordValid: Observable<Bool>
    let isVerifyPasswordValid: Observable<Bool>
    let isCorrespondPassword: Observable<Bool>
    let isRegisterEnabled: Observable<Bool>

    init() {
        let state = Observable
            .combineLatest(nameText, emailText, passwordText, verifyPasswordText) { UIState(nameText: $0, emailText: $1, passwordText: $2, verifyPasswordText: $3) }
        isNameValid = state.map { $0.isNameValid }
        isEmailValid = state.map { $0.isEmailValid }
        isPasswordValid = state.map { $0.isPasswordValid }
        isVerifyPasswordValid = state.map { $0.isVerifyPasswordValid }
        isCorrespondPassword = state.map { $0.isCorrespondPassword }
        isRegisterEnabled = state.map { $0.isRegisterEnabled }
    }

    func register() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.createUserAccount(email: emailText.value,
                                                 password: passwordText.value,
                                                 name: nameText.value) { (state) in
                                                    self.apiStateRelay.accept(state)
        }
    }
}
