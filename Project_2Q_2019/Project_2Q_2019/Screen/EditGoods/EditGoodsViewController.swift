//
//  EditGoodsViewController.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2020/06/22.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class EditGoodsViewController: UIViewController {
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var removeButton: RoundButton!
    @IBOutlet private weak var completeButton: RoundButton!
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
    }
    
    @IBAction private func remove(_ sender: Any) {
        
    }
    
    @IBAction private func complete(_ sender: Any) {
        
    }
    @IBAction private func categoryButtons(_ sender: UIButton) {
    }
        priceTextField.becomeFirstResponder()
// MARK: Keyboard Notifications
extension EditGoodsViewController {

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
