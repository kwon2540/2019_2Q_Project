//
//  AccountFormState.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/10/27.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation

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


