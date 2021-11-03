//
//  WelcomeViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/21.
//

import Foundation
import Firebase

class WelcomeViewModel {
    func signIn(email: String, password: String, signInHandler: @escaping (String?) -> ()) {
        let idErrorMessage = "There is no user record corresponding to this identifier. The user may have been deleted."
        let PWErrorMessage = "The password is invalid or the user does not have a password."
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let errorMessage = error?.localizedDescription {
                if errorMessage == idErrorMessage {
                    signInHandler("존재하지 않는 아이디입니다.")
                } else if errorMessage == PWErrorMessage {
                    signInHandler("비밀번호가 일치하지 않습니다.")
                } else {
                    signInHandler("로그인 중 오류가 발생했습니다. 다시 회원가입을 진행해주세요.")
                }
            } else {
                signInHandler(nil)
            }
        }
    }
    
    func addUserdefault(email: String, userdefaultHandler: @escaping () -> ()) {
        let userdefault = UserDefaults.standard
        Firestore.firestore().collection("UserDataBase").document(email).getDocument { document, error in
            if let error = error {
                print("유저 정보 탐색 오류: \(error)")
            } else {
                let email = document?.get("email") as! String
                let nickname = document?.get("nickname") as! String
                let introduce = document?.get("introduce") as! String
                let collectibles = document?.get("collectibles") as! [String]
                userdefault.set(email, forKey: "email")
                userdefault.set(nickname, forKey: "nickname")
                userdefault.set(introduce, forKey: "introduce")
                userdefault.set(collectibles, forKey: "collectibles")
                userdefaultHandler()
            }
        }
    }
    
}
