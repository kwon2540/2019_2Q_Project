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

protocol AuthManager {
    func createUserAccount(email: String, password: String, name: String, completion: @escaping (ApiState) -> Void)
    func signIn(email: String, password: String, completion: @escaping (ApiState) -> Void)
}

enum ApiState {
    case success
    case failed(error: String)
}

struct FirebaseManager: AuthManager {

    enum Collections: String {
        case users
        case goodslist

        var key: String {
            return self.rawValue
        }
    }

    static var shared = FirebaseManager()

    private init() {}

    func checkLogin() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }

    func createUserAccount(email: String, password: String, name: String, completion: @escaping (ApiState) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                return completion(.failed(error: error.debugDescription))
            }

            guard let uid = Auth.auth().currentUser?.uid else { return }

            let userModel = UserModel(email: email, name: name, uid: uid, startDate: Date())
            guard let data = try? FirestoreEncoder().encode(userModel) else { return }

            Firestore.firestore().collection(Collections.users.key).document(uid).setData(data) { (error) in
                if error != nil {
                    return completion(.failed(error: error.debugDescription))
                }
                completion(.success)
            }
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

    func signOut() {
        try? Auth.auth().signOut()
    }

    func addGoods(dateList: [DateList], completion: @escaping (ApiState) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let goodsListModel = GoodsListModel(uid: uid, dateList: dateList)
        guard let data = try? FirestoreEncoder().encode(goodsListModel) else { return }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).setData(data) { (error) in
            if error != nil {
                return completion(.failed(error: error.debugDescription))
            }
            completion(.success)
        }
    }

    // TODO: 임시
    func loadGoodsList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(Collections.goodslist.key).document(uid).getDocument { (snapshot, error) in
            if error != nil {

            }
            print(snapshot?.data() ?? "")
        }
    }
}
