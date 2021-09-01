//
//  EditProfileViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/01.
//

import Foundation
import Firebase
import FirebaseFirestore

class EditProfileViewModel {
    
    let collection = Firestore.firestore().collection("UserDataBase")
    
    func isNicknameValid(_ nickname: String?) -> Bool {
        let nicknameReg = "^[가-힣]{1,4}$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameReg)
        return nicknameTest.evaluate(with: nickname)
    }
    
    // firestore에 들어갈 수 았는 형태로 email 변형
    func storableEmail(_ email: String) -> String {
        var storableEmail = email.replacingOccurrences(of: ".", with: "-")
        storableEmail = storableEmail.replacingOccurrences(of: "@", with: "-")
        return storableEmail
    }
    
    func addUserInfo(_ email: String, _ uid: String, _ nickname: String, _ introduce: String) {
        collection.document(email)
            .setData(["email": email, "uid": uid, "nickname": nickname, "introduce": introduce]) { error in
            if error != nil {
                print("Error saving user data : \(error!)")
            }
        }
    }
    
    func deleteUserInfo(_ email: String, _ uid: String) {
        collection.document(email).delete() { error in
            if error != nil {
                print("Error deleting user data : \(error!)")
            }
        }
    }
    
}
