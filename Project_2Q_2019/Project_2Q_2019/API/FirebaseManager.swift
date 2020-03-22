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

// MARK: APIManager
protocol APIManager {
    func checkLogin() -> Bool
    func createUserAccount(email: String, password: String, name: String, completion: @escaping (APIState) -> Void)
    func signIn(email: String, password: String, completion: @escaping (APIState) -> Void)
    func signOut()
    func addGoodsDatedate(dateList: [String], completion: @escaping (APIState) -> Void)
    func addGoods(date: String, goods: [Goods], completion: @escaping (APIState) -> Void)
    func loadGoodsDateList(completion: @escaping (GoodsDateListModel?, APIState) -> Void)
    func loadGoodsList(date: String?, completion: @escaping (GoodsListModel?, APIState) -> Void)
    func deleteGoodsList(date: String, completion: @escaping (APIState) -> Void)
}

// MARK: APIStateProtocol
protocol APIStateProtocol {
    var apiStateRelay: PublishRelay<APIState> { get }
}

extension APIStateProtocol {
    var apiState: Signal<APIState> { apiStateRelay.asSignal() }
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
        case encodeError

        var description: String {
            switch self {
            case .firebaseError(let debugDescription):
                return debugDescription
            case .authError:
                return "Auth Error"
            case .encodeError:
                return "Encode Error"
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
                // 회원가입 실패인 경우
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }

            guard let uid = Auth.auth().currentUser?.uid else {
                // UID 인증 할수 없는 경우
                return completion(.failed(error: .authError))
            }

            let userModel = UserModel(email: email, name: name, uid: uid, startDate: Date())

            guard let data = try? FirestoreEncoder().encode(userModel) else {
                // 엔코딩 실패인 경우
                return completion(.failed(error: .encodeError))
            }

            Firestore.firestore().collection(Collections.users.key).document(uid).setData(data) { (error) in
                if error != nil {
                    // 콜렉션 추가에 실패한 경우
                    return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
                }
                completion(.success)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (APIState) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                // 로그인 실패인 경우
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }

    func addGoodsDatedate(dateList: [String], completion: @escaping (APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // 로그인 인증 할수 없는 경우
            return completion(.failed(error: .authError))
        }

        let goodsDateListModel = GoodsDateListModel(dateList: dateList)
        guard let data = try? FirestoreEncoder().encode(goodsDateListModel) else {
            // 엔코딩 실패인 경우
            return completion(.failed(error: .encodeError))
        }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).setData(data) { (error) in
            if error != nil {
                // 콜렉션 추가에 실패한 경우
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    func addGoods(date: String, goods: [Goods], completion: @escaping (APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // 로그인 인증 할수 없는 경우
            return completion(.failed(error: .authError))
        }

        let goodsListModel = GoodsListModel(goods: goods)
        guard let data = try? FirestoreEncoder().encode(goodsListModel) else {
            // 엔코딩 실패인 경우
            return completion(.failed(error: .encodeError))
        }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection(date).document(date).setData(data) { (error) in
            if error != nil {
                // 콜렉션 추가에 실패한 경우
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    func loadGoodsDateList(completion: @escaping (GoodsDateListModel?, APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // UID 인증 할수 없는 경우
            return completion(nil, .failed(error: .authError))
        }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).getDocument { (snapshot, error) in
            if error != nil {
                // 파이어베이스 에러인 경우
                return completion(nil, .failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }

            guard let snapshotData = snapshot?.data(),
                let data = try? FirestoreDecoder().decode(GoodsDateListModel.self, from: snapshotData) else {
                    // 스냅샷 데이터가 없는경우
                    return completion(nil, .success)
            }

            completion(data, .success)
        }
    }

    func loadGoodsList(date: String?, completion: @escaping (GoodsListModel?, APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // UID 인증 할수 없는 경우
            return completion(nil, .failed(error: .authError))
        }

        var documentReference: DocumentReference
        if let date = date {
            documentReference = Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection(date).document(date)
        } else {
            documentReference = Firestore.firestore().collection(Collections.goodslist.key).document(uid)
        }

        documentReference.getDocument { (snapshot, error) in
            if error != nil {
                // 파이어베이스 에러인 경우
                return completion(nil, .failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }

            guard let snapshotData = snapshot?.data(),
                let data = try? FirestoreDecoder().decode(GoodsListModel.self, from: snapshotData) else {
                    // 스냅샷 데이터가 없는경우
                    return completion(nil, .success)
            }

            completion(data, .success)
        }
    }

    func deleteGoodsList(date: String, completion: @escaping (APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // UID 인증 할수 없는 경우
            return completion(.failed(error: .authError))
        }

        Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection(date).document(date).delete { (error) in
            if error != nil {
                // 파이어베이스 에러인 경우
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }
}
