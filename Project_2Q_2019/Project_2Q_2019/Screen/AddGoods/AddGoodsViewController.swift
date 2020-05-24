//
//  AddGoodsViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/01/25.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import RxSwift

final class AddGoodsViewController: UIViewController, StoryboardInstantiable {

    enum TextFieldTag: Int {
        case nameTextField
        case priceTextField
        case amountTextField
    }

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addButton: RoundButton!

    private let disposeBag = DisposeBag()

    var viewModel: AddGoodsViewModel!

    var dismissed: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        //        nameTextField.delegate = self

        setupLayouts()

        bindViewModel()
    }

    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        addKeyboardObservers()
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        removeKeyboardObservers()
    //    }

    @IBAction private func dismiss(_ sender: Any) {
        dismissed?()
        dismiss(animated: true)
    }

    @IBAction private func addGoods(_ sender: Any) {

    }

    private func setupLayouts() {

    }

    private func bindViewModel() {

        // Input
        //        nameTextField.rx.text.orEmpty
        //            .bind(to: viewModel.nameText)
        //            .disposed(by: disposeBag)

        // Output
        //        viewModel.isAddButtonValid
        //            .bind(to: addButton.rx.isEnabled)
        //            .disposed(by: disposeBag)

        //        viewModel.apiState.emit(onNext: { [weak self] (state) in
        //            guard let this = self, let view = this.view else { return }
        //
        //            switch state {
        //            // 로딩 시 인디케이터 표시
        //            case .loading:
        //                ActivityIndicator.shared.start(view: view)
        //            // 성공시 인디케이터 중지 및 디스미스
        //            case .success:
        //                ActivityIndicator.shared.stop(view: view)
        //                this.dismiss(animated: true) { [weak self] in
        //                    guard let this = self else { return }
        //                    this.dismissed?()
        //                }
        //            // 실패시 드롭다운 표시 및 에러 핸들링 인디케이터 중지
        //            case .failed(let error):
        //                DropDownManager.shared.showDropDownNotification(view: view,
        //                                                                width: nil,
        //                                                                height: nil,
        //                                                                type: .error,
        //                                                                message: error.description)
        //                apiErrorLog(logMessage: error.description)
        //                ActivityIndicator.shared.stop(view: view)
        //                this.dismiss(animated: true)
        //            }
        //        }).disposed(by: disposeBag)
    }
}

extension AddGoodsViewController: UITextFieldDelegate {

    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        switch TextFieldTag.init(rawValue: textField.tag) {
    //        case .nameTextField:
    //            priceTextField.becomeFirstResponder()
    //        default:
    //            break
    //        }
    //        return true
    //    }
    //
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        switch TextFieldTag.init(rawValue: textField.tag) {
    //        case .amountTextField:
    //            textField.text = ""
    //        default:
    //            break
    //        }
    //    }
}

// MARK: Keyboard Notifications
extension AddGoodsViewController {

    //    private func addKeyboardObservers() {
    //        let notificationCenter = NotificationCenter.default
    //        notificationCenter.addObserver(self,
    //                                       selector: #selector(handleContentUnderKeyboard(notification:)),
    //                                       name: UIResponder.keyboardWillHideNotification, object: nil)
    //        notificationCenter.addObserver(self,
    //                                       selector: #selector(handleContentUnderKeyboard(notification:)),
    //                                       name: UIResponder.keyboardWillChangeFrameNotification,
    //                                       object: nil)
    //    }
    //
    //    private func removeKeyboardObservers() {
    //        let notificationCenter = NotificationCenter.default
    //        notificationCenter.removeObserver(self)
    //    }
    //
    //    @objc private func handleContentUnderKeyboard(notification: Notification) {
    //        guard let userInfo = notification.userInfo,
    //            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    //
    //        switch notification.name {
    //        case UIResponder.keyboardWillHideNotification:
    //            moveContentForDismissKeyboard()
    //        default:
    //            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, to: view.window)
    //            moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
    //        }
    //    }
    //
    //    private func moveContentForDismissKeyboard() {
    //        scrollViewBottomContraints.constant = 0
    //    }
    //
    //    private func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
    //        scrollViewBottomContraints.constant = keyboardFrame.height
    //    }
}
