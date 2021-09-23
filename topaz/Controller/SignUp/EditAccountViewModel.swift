//
//  EditAccountViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/08/31.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditAccountViewModel {
    
    let collection = Firestore.firestore().collection("UserDataBase")
    
    func isEmailValid(_ email: String?) -> Bool {
        let emailReg = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }

    func isPWValid(_ password: String) -> Bool {
        let passwordReg = "^(?=.*[a-z])(?=.*[0-9]).{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordTest.evaluate(with: password)
    }
    
    func isExist(email: String, emailHandler: @escaping () -> ()) {
        collection.whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                print("이메일 탐색 에러 : \(error)")
            } else {
                if querySnapshot!.documents.count != 0 {
                    emailHandler()
                }
            }
        }
    }
}
