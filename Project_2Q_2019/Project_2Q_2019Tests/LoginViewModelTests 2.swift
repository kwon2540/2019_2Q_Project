//
//  LoginViewModelTests.swift
//  Project_2Q_2019Tests
//
//  Created by JUNHYEOK KWON on 2019/10/27.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import Project_2Q_2019

final class LoginViewModelTests: XCTestCase {

    func testIsEnabled() {

        let viewModel = LoginViewModel()
        let disposeBag = DisposeBag()

        let testScheduler = TestScheduler(initialClock: 0)

        testScheduler.scheduleAt(0) {
            viewModel.emailText.onNext("")
            viewModel.passwordText.onNext("")
        }

        testScheduler.scheduleAt(10) {
            viewModel.emailText.onNext("hoge")
            viewModel.passwordText.onNext("hoge")
        }

        let observer = testScheduler.createObserver(Bool.self)

        viewModel.isLoginEnabled
            .bind(to: observer)
            .disposed(by: disposeBag)

        //        let events = observer.events
        //        XCTAssertEqual(events, [.next(0, true), .next(10, true)])
    }

    //    func testIsEnabled_理想() {
    //
    //        let viewModel = LoginViewModel()
    //
    //        viewModel.emailText.value = "hoge"
    //        viewModel.passwordText.value = "hoge"
    //
    //        XCTAssertEqual(viewModel.isEnabled.value, true)
    //    }

    func testIsEnabled_No2() {
        let state = LoginViewModel.State(
            emailText: "@.",
            passwordText: "12345678"
        )

        XCTAssertEqual(state.isLoginEnabled, true)
    }
}
