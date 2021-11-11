//
//  HomeViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import Foundation
import Firebase

class HomeViewModel {
    let database = Firestore.firestore()
    let userdefault = UserDefaults.standard
    
    func addCollectibles() {
        let email = userdefault.string(forKey: "email")!
        let collection = database.collection("UserDataBase")
        collection.document(email).updateData(["collectibles" : FieldValue.arrayUnion(["welcomeSnowBall"])]) { error in
            if let error = error {
                print("수집품 추가 에러: \(error)")
            } else {
                print("Add Collectibles Success")
                // also add in Userdefault
                var collectibles = self.userdefault.stringArray(forKey: "collectibles")!
                collectibles.append("welcomeSnowBall")
                self.userdefault.set(collectibles, forKey: "collectibles")
            }
        }
    }
}
