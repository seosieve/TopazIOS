//
//  CompleteViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/21.
//

import Foundation
import Firebase

class CompleteViewModel {
    func signIn(email: String, password: String, signInHandler: @escaping () -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("로그인 에러 : \(error)")
            } else {
                signInHandler()
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
                let blockedUsers = document?.get("blockedUsers") as! [String]
                userdefault.set(email, forKey: "email")
                userdefault.set(nickname, forKey: "nickname")
                userdefault.set(introduce, forKey: "introduce")
                userdefault.set(collectibles, forKey: "collectibles")
                userdefault.set(blockedUsers, forKey: "blockedUsers")
                userdefaultHandler()
            }
        }
    }
}
