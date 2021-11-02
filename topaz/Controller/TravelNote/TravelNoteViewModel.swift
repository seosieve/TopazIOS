//
//  TravelNoteViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import Foundation
import Firebase

class TravelNoteViewModel {
    let database = Firestore.firestore()
    
    func getUserDataBase(email: String, userDataBaseHandler: @escaping (String, [String], [String]) -> ()) {
        let collection = database.collection("UserDataBase")
        collection.document(email).getDocument { document, error in
            if let error = error {
                print("유저 불러오기 에러 : \(error)")
            } else {
                if let document = document {
                    let imageUrl = document.get("imageUrl") as! String
                    let collectibles = document.get("collectibles") as! [String]
                    let topazAlbumUrl = document.get("topazAlbumUrl") as! [String]
                    userDataBaseHandler(imageUrl, collectibles, topazAlbumUrl)
                }
            }
        }
    }
}
