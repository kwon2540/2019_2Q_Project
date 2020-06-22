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
    func addGoods(goods: Goods, completion: @escaping (APIState) -> Void)
    func loadGoods(completion: @escaping ([Goods]?, APIState) -> Void)
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
                // Failed Create
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }

            guard let uid = Auth.auth().currentUser?.uid else {
                // Failed Get UID
                return completion(.failed(error: .authError))
            }

            let user = User(email: email, name: name, uid: uid, startDate: Date())

            guard let data = try? FirestoreEncoder().encode(user) else {
                // Failed Encode
                return completion(.failed(error: .encodeError))
            }

            Firestore.firestore().collection(Collections.users.key).document(uid).setData(data) { (error) in
                if error != nil {
                    // Failed Add Collection Data
                    return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
                }
                completion(.success)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (APIState) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                // Failed Login
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }

    func addGoods(goods: Goods, completion: @escaping (APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // Failed Login
            return completion(.failed(error: .authError))
        }

        guard let data = try? FirestoreEncoder().encode(goods) else {
            // Failed Encode
            return completion(.failed(error: .encodeError))
        }
        
        Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection("goods").document(goods.id).setData(data) { (error) in
            if error != nil {
                // Failed Add Collection Data
                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }
            completion(.success)
        }
    }

    func loadGoods(completion: @escaping ([Goods]?, APIState) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
            // Failed Login
            return completion(nil, .failed(error: .authError))
        }
        
        Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection("goods").getDocuments { (snapshot, error) in
            if error != nil {
                // Failed Add Collection Data
                return completion(nil, .failed(error: .firebaseError(debugDescription: error.debugDescription)))
            }

            guard let snapshotData = snapshot?.documents else {
                // Failed Get Snapshot Data
                return completion(nil, .success)
            }
            
            let goods = snapshotData.compactMap {
                try? FirestoreDecoder().decode(Goods.self, from: $0.data())
            }

            completion(goods, .success)
        }
//
//        Firestore.firestore().collection(Collections.goodslist.key).document(uid).getDocument { (snapshot, error) in
//            if error != nil {
//                // 파이어베이스 에러인 경우
//                return completion(nil, .failed(error: .firebaseError(debugDescription: error.debugDescription)))
//            }
//
//            guard let snapshotData = snapshot?.data(),
//                let data = try? FirestoreDecoder().decode(GoodsList.self, from: snapshotData) else {
//                    // 스냅샷 데이터가 없는경우
//                    return completion(nil, .success)
//            }
//
//            completion(data, .success)
//        }
    }

//    func loadGoodsList(date: String?, completion: @escaping (GoodsListModel?, APIState) -> Void) {
//
//        guard let uid = Auth.auth().currentUser?.uid else {
//            // UID 인증 할수 없는 경우
//            return completion(nil, .failed(error: .authError))
//        }
//
//        var documentReference: DocumentReference
//        if let date = date {
//            documentReference = Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection(date).document(date)
//        } else {
//            documentReference = Firestore.firestore().collection(Collections.goodslist.key).document(uid)
//        }
//
//        documentReference.getDocument { (snapshot, error) in
//            if error != nil {
//                // 파이어베이스 에러인 경우
//                return completion(nil, .failed(error: .firebaseError(debugDescription: error.debugDescription)))
//            }
//
//            guard let snapshotData = snapshot?.data(),
//                let data = try? FirestoreDecoder().decode(GoodsListModel.self, from: snapshotData) else {
//                    // 스냅샷 데이터가 없는경우
//                    return completion(nil, .success)
//            }
//
//            completion(data, .success)
//        }
//    }
//
//    func deleteGoodsList(date: String, completion: @escaping (APIState) -> Void) {
//
//        guard let uid = Auth.auth().currentUser?.uid else {
//            // UID 인증 할수 없는 경우
//            return completion(.failed(error: .authError))
//        }
//
//        Firestore.firestore().collection(Collections.goodslist.key).document(uid).collection(date).document(date).delete { (error) in
//            if error != nil {
//                // 파이어베이스 에러인 경우
//                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
//            }
//            completion(.success)
//        }
//    }
//
//    func updateDateList(dateList: [String], completion: @escaping (APIState) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            // UID 인증 할수 없는 경우
//            return completion(.failed(error: .authError))
//        }
//
//        Firestore.firestore().collection(Collections.goodslist.key).document(uid).updateData(["dateList": dateList]) { (error) in
//            if error != nil {
//                // 파이어베이스 에러인 경우
//                return completion(.failed(error: .firebaseError(debugDescription: error.debugDescription)))
//            }
//            completion(.success)
//        }
//    }
}
