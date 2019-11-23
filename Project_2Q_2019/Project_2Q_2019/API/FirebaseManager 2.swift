//
//  FirebaseAuthManager.swift
//  Project_2Q_2019
//
//  Created by JUNHYEOK KWON on 2019/11/04.
//  Copyright © 2019 JUNHYEOK KWON. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

protocol AuthManager: class {
    func createUserAccount(email: String, password: String, name: String, completion: @escaping (ApiState) -> Void)
    func signIn(email: String, password: String, completion: @escaping (ApiState) -> Void)
}

enum ApiState {
    case success
    case failed(error: String)
}

class FirebaseManager: AuthManager {

    static var shared = FirebaseManager()

    private init() {}

    func createUserAccount(email: String, password: String, name: String, completion: @escaping (ApiState) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                return completion(.failed(error: error.debugDescription))
            }

            guard let uid = Auth.auth().currentUser?.uid else { return }

            let userModel = UserModel(email: email, name: name, uid: uid, startDate: Date())
            guard let data = try? FirestoreEncoder().encode(userModel) else { return }

            Firestore.firestore().collection("users").document(uid).setData(data, completion: { (error) in
                if error != nil {
                    return completion(.failed(error: error.debugDescription))
                }
                completion(.success)
            })
        }
    }

    func signIn(email: String, password: String, completion: @escaping (ApiState) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                return completion(.failed(error: error.debugDescription))
            }
            completion(.success)
        }
    }
}
