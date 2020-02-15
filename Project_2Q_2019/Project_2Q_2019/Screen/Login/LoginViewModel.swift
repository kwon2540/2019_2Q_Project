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

struct LoginViewModel: APIStateProtocol {

    struct UIState: AccountLoginStateProtocol {

        let emailText: String
        let passwordText: String
    }

    let emailText = BehaviorRelay(value: "")
    let passwordText = BehaviorRelay(value: "")

    let isEmailValid: Observable<Bool>
    let isPasswordValid: Observable<Bool>
    let isLoginEnabled: Observable<Bool>
    
    let apiStateRelay = PublishRelay<APIState>()

    init() {
        let state = Observable
            .combineLatest(emailText, passwordText) { UIState(emailText: $0, passwordText: $1) }
        isEmailValid = state.map { $0.isEmailValid }
        isPasswordValid = state.map { $0.isPasswordValid }
        isLoginEnabled = state.map { $0.isLoginEnabled }
    }
}
