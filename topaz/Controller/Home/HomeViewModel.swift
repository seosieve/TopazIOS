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
    var userdefault = UserDefaults.standard
    
    func addCollectibles() {
        let email = userdefault.string(forKey: "email")!
        let collection = database.collection("UserDataBase")
        collection.document(email).updateData(["collectibles" : FieldValue.arrayUnion(["welcomeSnowBall"])])
        var collectibles = userdefault.stringArray(forKey: "collectibles")!
        collectibles.append("welcomeSnowBall")
        userdefault.set(collectibles, forKey: "collectibles")
    }
    
}
