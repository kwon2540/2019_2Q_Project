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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
