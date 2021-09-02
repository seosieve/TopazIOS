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
    
    // firestore에 들어갈 수 았는 형태로 email 변형
    func storableEmail(_ email: String) -> String {
        var storableEmail = email.replacingOccurrences(of: ".", with: "-")
        storableEmail = storableEmail.replacingOccurrences(of: "@", with: "-")
        return storableEmail
    }
    
//    func isExist(_ email: String) -> Bool {
//        var a = true
//        Firestore.firestore().collection("UserDataBase").whereField("email", isEqualTo: email).getDocuments{ querySnapshot, error in
//            if querySnapshot!.documents.count != 0 {
//                a = false
//            } else {
//                a = true
//            }
//        }
//        print(a)
//        return a
//    }
    
    
}

class EditAccountViewModell {
    func isExist(_ email: String) -> Bool {
        var a = true
        Firestore.firestore().collection("UserDataBase").whereField("email", isEqualTo: email).getDocuments{ querySnapshot, error in
            if querySnapshot!.documents.count != 0 {
                a = false
            } else {
                a = true
            }
        }
        return a
    }
}
