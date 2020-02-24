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
import RxCocoa

protocol APIManager {
    func checkLogin() -> Bool
    func createUserAccount(email: String, password: String, name: String, completion: @escaping (APIState) -> Void)
    func signIn(email: String, password: String, completion: @escaping (APIState) -> Void)
    func signOut()
    func addGoods(dateList: [DateList], completion: @escaping (APIState) -> Void)
    func loadGoodsList(completion: @escaping (APIState) -> Void)
}

enum APIState {
    case loading
    case success
    case failed(error: FirebaseManager.Error)
}

struct FirebaseManager: APIManager {

    enum Collections: String {
        case users
        case goodslist

        var key: String {
            return self.rawValue
        }
    }

    enum Error {
        case firebaseError(debugDescription: String)
        case authError
        case loadError
        case encodeError
        case decodeError

        var description: String {
            switch self {
            case .firebaseError(let debugDescription):
                return debugDescription
            case .authError:
                return "Auth Error"
            case .loadError:
                return "Load Error"
            case .encodeError:
                return "Encode Error"
            case .decodeError:
                return "Decode Error"

            }
        }
    }

    static var shared = FirebaseManager()

    private init() {}

    func checkLogin() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }

    func createUserAccount(email: String, password: String, name: String, completion: @escaping (APIState) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }

            guard let uid = Auth.auth().currentUser?.uid else {
                return completion(.failed(error: .authError))
            }

            let userModel = UserModel(email: email, name: name, uid: uid, startDate: Date())

            guard let data = try? FirestoreEncoder().encode(userModel) else {
                return completion(.failed(error: .encodeError))
            }

            Firestore.firestore().collection(Collections.users.key).document(uid).setData(data) { (error) in
                if error != nil {
                    return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
                }
                completion(.success)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (APIState) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }

    func addGoods(dateList: [DateList], completion: @escaping (APIState) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return completion(.failed(error: .authError))
        }

        let goodsListModel = GoodsListModel(uid: uid, dateList: dateList)
        guard let data = try? FirestoreEncoder().encode(goodsListModel) else {
            return completion(.failed(error: .encodeError))
        }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).setData(data) { (error) in
            if error != nil {
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    // TODO: 임시
    func loadGoodsList(completion: @escaping (APIState) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return completion(.failed(error: .authError))
        }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).getDocument { (snapshot, error) in
            if error != nil {

            }
            print(snapshot?.data() ?? "")
        }
    }
}

// MARK: APIStateProtocol
protocol APIStateProtocol {
    var apiStateRelay: PublishRelay<APIState> { get }
}

extension APIStateProtocol {
    var apiState: Signal<APIState> { apiStateRelay.asSignal() }
}
