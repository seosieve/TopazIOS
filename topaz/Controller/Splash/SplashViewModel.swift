//
//  SplashViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/12.
//

import Foundation
import Firebase

class SplashViewModel {
    func addUserdefault(email: String, userdefaultHandler: @escaping () -> ()) {
        let userdefault = UserDefaults.standard
        Firestore.firestore().collection("UserDataBase").document(email).getDocument { document, error in
            if let error = error {
                print("유저 정보 탐색 오류: \(error)")
            } else {
                let email = document?.get("email") as! String
                let nickname = document?.get("nickname") as! String
                let introduce = document?.get("introduce") as! String
                userdefault.set(email, forKey: "email")
                userdefault.set(nickname, forKey: "nickname")
                userdefault.set(introduce, forKey: "introduce")
                userdefaultHandler()
            }
        }
    }
}
