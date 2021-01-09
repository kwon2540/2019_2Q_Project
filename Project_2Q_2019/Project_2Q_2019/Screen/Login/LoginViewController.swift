//
//  LoginViewController.swift
//  Project_2Q_2019
//
//  Created by Kwon junhyeok on 2021/01/02.
//  Copyright © 2021 JUNHYEOK KWON. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import RxSwift

class LoginViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private weak var loginButton: UIButton!
    
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()

    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        bindViewModel()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 4
    }
    
    private func bindViewModel() {
        // API
        viewModel.apiState.emit(onNext: { [weak self] (state) in
            guard let this = self, let view = this.view else { return }

            switch state {
            // Show indicator when loading
            case .loading:
                ActivityIndicator.shared.start(view: view)
            // Stop indicator and transition to Home when success
            case .success:
                ActivityIndicator.shared.stop(view: view)
                AppDelegate.shared.rootViewController.showHomeScreen()
            // Error handling when failed
            case .failed(let error):
                DropDownManager.shared.showDropDownNotification(view: view,
                                                                width: nil,
                                                                height: nil,
                                                                type: .error,
                                                                message: error.description)
                apiErrorLog(logMessage: error.description)
                ActivityIndicator.shared.stop(view: view)
            }
        }).disposed(by: disposeBag)
    }
    
    private func trasitionToHomeScreen() {
        AppDelegate.shared.rootViewController.showHomeScreen()
    }
    
    @IBAction private func didTapLoginButton(_ sender: Any) {
        startSignInWithAppleFlow()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.delegate?.window else {
            fatalError()
        }
        return window!
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    print(error ?? "")
                    return
                }
                
                let uid = authResult?.user.uid ?? ""
                let givenName = appleIDCredential.fullName?.givenName ?? ""
                let familyName = appleIDCredential.fullName?.familyName ?? ""
                let fullName = "\(givenName) \(familyName)"
                
                //　isNewUserがTrueの場合のみ、UserInfoをDBに登録する
                if authResult?.additionalUserInfo?.isNewUser ?? false {
                    self.viewModel.registUserInfo(name: fullName, uid: uid)
                } else {
                    AppDelegate.shared.rootViewController.showHomeScreen()
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
