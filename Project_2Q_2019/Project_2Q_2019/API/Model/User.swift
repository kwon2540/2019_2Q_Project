//
//  UserModel.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/09.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import Foundation

struct User: Codable {

    let email: String
    let name: String
    let uid: String
    let startDate: Date
}
