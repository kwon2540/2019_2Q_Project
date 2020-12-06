//
//  EditBoughtGoodsViewController.swift
//  Project_2Q_2019
//
//  Created by Maharjan Binish on 2020/11/29.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

final class EditBoughtGoodsViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var revertButton: UIButton!
    @IBOutlet private weak var lifeButton: UIButton!
    @IBOutlet private weak var fashionButton: UIButton!
    @IBOutlet private weak var hobbiesButton: UIButton!
    @IBOutlet private weak var miscellaneousButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var nameSaperator: UIView!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var amountSaperator: UIView!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var priceSaperator: UIView!
    @IBOutlet private weak var keyboardSpaceConstraint:NSLayoutConstraint!
    
    
    @IBOutlet private weak var keyboardSpaceConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    @IBAction private func dismiss(_ sender: Any) {
        closeEditGoodsModal(isDataChanged: false)
    }

    @IBAction private func remove(_ sender: Any) {
        viewModel.deleteBoughtGoods()
    }

    @IBAction private func revert(_ sender: Any) {
        // TODO
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
// MARK: Keyboard Notifications
extension EditBoughtGoodsViewController {

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
    }
}
