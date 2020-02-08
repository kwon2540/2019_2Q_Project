//
//  AddGoodsViewController.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2020/01/25.
//  Copyright © 2020 JUNHYEOK KWON. All rights reserved.
//

import UIKit

class AddGoodsViewController: UIViewController, GetStoryboard {

    enum TextFieldTag: Int {
        case nameTextField
        case priceTextField
        case countTextField
    }

    @IBOutlet private weak var scrollViewBottomContraints: NSLayoutConstraint!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var countTextField: UITextField!

    var viewModel: AddGoodsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        priceTextField.delegate = self
        countTextField.delegate = self

        nameTextField.becomeFirstResponder()
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
        dismiss(animated: true)
    }
    @IBAction private func add(_ sender: Any) {
        guard let dateList = makeGoodsData() else { return }

        addGoodsToFirebase(dateList: dateList)
    }

    private func makeGoodsData() -> [DateList]? {
        guard let name = nameTextField.text else { return nil }

        let amount = countTextField.text
        let price = priceTextField.text

        let goods = Goods(name: name, amount: amount, price: price, isBought: false)

        var goodsData = viewModel.dateList

        if goodsData.isEmpty {
            goodsData = [DateList(date: viewModel.date, goods: [goods])]
        } else {
            if let index = goodsData.firstIndex(where: { $0.date == viewModel.date }) {
                goodsData[index].goods.append(goods)
            } else {
                goodsData.append(DateList(date: viewModel.date, goods: [goods]))
            }
        }

        return goodsData
    }

    private func addGoodsToFirebase(dateList: [DateList]) {
        ActivityIndicator.shared.start(view: self.view)

        FirebaseManager.shared.addGoods(dateList: dateList) { [weak self] (state) in
            guard let this = self, let view = this.view else { return }
            switch state {
            case .success:
                ActivityIndicator.shared.stop(view: view)
                this.dismiss(animated: true)
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error)
                ActivityIndicator.shared.stop(view: view)
            }
        }
    }
}

extension AddGoodsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch TextFieldTag.init(rawValue: textField.tag) {
        case .nameTextField:
            priceTextField.becomeFirstResponder()
        default:
            break
        }
        return true
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
        scrollViewBottomContraints.constant = 0
    }

    private func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        scrollViewBottomContraints.constant = keyboardFrame.height
    }
}
