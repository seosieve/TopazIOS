//
//  SettingViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/21.
//

import Foundation
import Firebase

class MySettingViewModel {
    let userdefault = UserDefaults.standard
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    func signOut(signOutHandler: @escaping () -> ()) {
        do {
            try Auth.auth().signOut()
            removeAllUserdefault()
            signOutHandler()
        } catch let error as NSError {
            print("로그아웃 에러 : \(error)")
        }
    }
    
    func removeAllUserdefault() {
        for key in userdefault.dictionaryRepresentation().keys {
            userdefault.removeObject(forKey: key.description)
        }
        print("Userdefaults Delete Succeed")
    }
    
    func withdraw(withdrawHandler: @escaping () -> ()) {
        let user = Auth.auth().currentUser
        let email = userdefault.string(forKey: "email")!
        user?.delete { error in
            if let error = error {
                print("유저 계정 삭제 에러 : \(error)")
            } else {
                self.removeUserImage(userEmail: email)
                self.removeUserDataBase(userEmail: email)
                self.removeAllUserdefault()
                withdrawHandler()
            }
        }
    }
    
    func removeUserDataBase(userEmail: String) {
        let collection = database.collection("UserDataBase")
        collection.document(userEmail).delete { error in
            if let error = error {
                print("유저 데이터베이스 삭제 에러 : \(error)")
            } else {
                print("User Database Delete Succeed")
            }
        }
    }
    
    func removeUserImage(userEmail: String) {
        let imageRef = storage.reference().child("UserProfileImages/\(userEmail).png")
        imageRef.delete { error in
            if let error = error {
                print("유저 이미지 삭제 에러 : \(error)")
            } else {
                print("User Image Delete Succeed")
            }
        }
    }
}
