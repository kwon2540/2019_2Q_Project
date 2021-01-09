//
//  LoginViewModel.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2021/01/02.
//  Copyright © 2021 JUNHYEOK KWON. All rights reserved.
//

import Foundation
import RxCocoa

struct LoginViewModel: APIStateProtocol {
    
    let apiStateRelay = PublishRelay<APIState>()

    func registUserInfo(name: String, uid: String) {
        apiStateRelay.accept(.loading)
        FirebaseManager.shared.registUserInfo(name: name, uid: uid) { (state) in
            self.apiStateRelay.accept(state)
        }
    }
}
