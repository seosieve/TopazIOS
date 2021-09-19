//
//  HomeViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import Foundation
import Firebase

class HomeViewModel {
    let db = Firestore.firestore()
    
    func getUserNickname(nicknameHandler: @escaping (String) -> ()) {
        let email = Auth.auth().currentUser!.email!
        var userNickname = ""
        db.collection("UserDataBase").document(email).getDocument { document, error in
            if let document = document {
                userNickname = document.get("nickname") as! String
                nicknameHandler(userNickname)
            } else {
                if let error = error {
                    print("유저 닉네임 탐색 오류 : \(error)")
                }
            }
        }
    }
    
    
}
