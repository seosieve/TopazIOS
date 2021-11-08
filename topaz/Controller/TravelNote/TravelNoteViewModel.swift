//
//  TravelNoteViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import Foundation
import Firebase

class TravelNoteViewModel {
    let userdefault = UserDefaults.standard
    let database = Firestore.firestore()
    
    func getUserImage(userImageHandler: @escaping (String) -> ()) {
        let email = userdefault.string(forKey: "email")!
        let collection = database.collection("UserDataBase")
        collection.document(email).getDocument { document, error in
            if let error = error {
                print("유저 불러오기 에러 : \(error)")
            } else {
                if let document = document {
                    let imageUrl = document.get("imageUrl") as! String
                    userImageHandler(imageUrl)
                }
            }
        }
    }
    
    func getUserAlbum(userAlbumHandler: @escaping ([String], [String], [String]) -> ()) {
        let email = userdefault.string(forKey: "email")!
        let collection = database.collection("UserDataBase")
        collection.document(email).getDocument { document, error in
            if let error = error {
                print("유저 불러오기 에러 : \(error)")
            } else {
                if let document = document {
                    let albumUrl = document.get("albumUrl") as! [String]
                    let albumName = document.get("albumName") as! [String]
                    let albumDate = document.get("albumDate") as! [String]
                    userAlbumHandler(albumUrl, albumName, albumDate)
                }
            }
        }
    }
    
    func getUserTicket(userTicketHandler: @escaping ([String], [String]) -> ()) {
        let email = userdefault.string(forKey: "email")!
        let collection = database.collection("UserDataBase")
        collection.document(email).getDocument { document, error in
            if let error = error {
                print("유저 불러오기 에러 : \(error)")
            } else {
                if let document = document {
                    let ticketName = document.get("ticketName") as! [String]
                    let ticketDate = document.get("ticketDate") as! [String]
                    userTicketHandler(ticketName, ticketDate)
                }
            }
        }
    }
    
    
}
