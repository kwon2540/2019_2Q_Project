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

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var addButton: RoundButton!
    @IBOutlet private weak var lifeButton: UIButton!
    @IBOutlet private weak var fashionButton: UIButton!
    @IBOutlet private weak var hobbiesButton: UIButton!
    @IBOutlet private weak var miscellaneousButton: UIButton!
    @IBOutlet private weak var nameSaperator: UIView!
    @IBOutlet private weak var keyboardSpaceConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()

    private lazy var categoryButtons: [UIButton] = [lifeButton, fashionButton, hobbiesButton, miscellaneousButton]

    var viewModel: AddGoodsViewModel!
    var dismissed: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayouts()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    @IBAction private func dismiss(_ sender: Any) {
        closeAddGoodsModal(isDataChanged: false)
    }

    @IBAction private func addGoods(_ sender: Any) {
        guard let tag = categoryButtons.filter({ $0.isSelected }).first?.tag else { return }
        viewModel.addGoods(selectedButtonTag: tag)
    }

    @IBAction private func categoryButtons(_ sender: UIButton) {
        guard !sender.isSelected else { return }

        categoryButtons[sender.tag].isSelected = true
        categoryButtons.enumerated().forEach { index, button in
            if index != sender.tag {
                button.isSelected = false
            }
        }
    }

    private func setupLayouts() {
        mainView.layer.cornerRadius = 20
        mainView.clipsToBounds = true

        addButton.isEnabled = false

        lifeButton.isSelected = true

        nameTextField.becomeFirstResponder()
    }
    
    private func closeAddGoodsModal(isDataChanged: Bool) {
        dismissed?(isDataChanged)
        dismiss(animated: true)
    }

    private func bindViewModel() {

        // Input
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)

        // Output
        viewModel.isAddButtonEnabled
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.nameSaperatorColor
            .bind(to: nameSaperator.rx.backgroundColor)
            .disposed(by: disposeBag)

        // API
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }
            
            switch state {
            // Show indicator when loading
            case .loading:
                ActivityIndicator.shared.start(view: view)
            // Stop indicator and dismiss when success
            case .success:
                ActivityIndicator.shared.stop(view: view)
                this.closeAddGoodsModal(isDataChanged: true)
            // Error handling when failed
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.stop(view: view)
                this.closeAddGoodsModal(isDataChanged: false)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: Keyboard Notifications
extension AddGoodsViewController {

    private func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleContentUnderKeyboard(notification:)),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleContentUnderKeyboard(notification:)),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }

    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc private func handleContentUnderKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            moveContentForDismissKeyboard()
        default:
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, to: view.window)
            moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
        }
    }

    private func moveContentForDismissKeyboard() {
        keyboardSpaceConstraint.constant = 0
    }

    private func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        keyboardSpaceConstraint.constant = keyboardFrame.height
    }
}
