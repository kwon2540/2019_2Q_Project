//
//  LoginViewModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/09/23.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: AccountLoginStateProtocol
protocol AccountLoginStateProtocol {

    var emailText: String { get }
    var passwordText: String { get }
}

extension AccountLoginStateProtocol {

    var isEmailValid: Bool {
        return emailText.contains("@") && emailText.contains(".")
    }

    var isPasswordValid: Bool {
        return passwordText.count > 5
    }

    var isLoginEnabled: Bool {
        return isPasswordValid && isEmailValid
    }
}

struct LoginViewModel: APIStateProtocol {

    struct UIState: AccountLoginStateProtocol {

        let emailText: String
        let passwordText: String
    }

    let apiStateRelay = PublishRelay<APIState>()

    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")

    let isEmailValid: Observable<Bool>
    let isPasswordValid: Observable<Bool>
    let isLoginEnabled: Observable<Bool>

    init() {
        let state = Observable
            .combineLatest(emailText, passwordText) { UIState(emailText: $0, passwordText: $1) }
        isEmailValid = state.map { $0.isEmailValid }
        isPasswordValid = state.map { $0.isPasswordValid }
        isLoginEnabled = state.map { $0.isLoginEnabled }
    }

    func login() {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.signIn(email: emailText.value, password: passwordText.value) { (state) in
            self.apiStateRelay.accept(state)
        }
    }
}
