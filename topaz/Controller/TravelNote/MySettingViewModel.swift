//
//  SettingViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/21.
//

import Foundation
import FirebaseAuth

class MySettingViewModel {
    let userdefault = UserDefaults.standard
    
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
    }
}
