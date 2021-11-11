//
//  BlockUserListViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/11/11.
//

import Foundation
import Firebase

class BlockUserListViewModel {
    let database = Firestore.firestore()
    let userdefault = UserDefaults.standard
    var imageUrlArr = [String]()
    var nicknameArr = [String]()
    var emailArr = [String]()
    
    func getBlockedUsers(blockedUserHandler: @escaping ([String], [String], [String]) -> ()) {
        imageUrlArr = []
        nicknameArr = []
        emailArr = []
        let blockedUsers = userdefault.stringArray(forKey: "blockedUsers")!
        let collection = database.collection("UserDataBase")
        if blockedUsers.count == 0 {
            blockedUserHandler(self.imageUrlArr, self.nicknameArr, self.emailArr)
        } else {
            collection.whereField("email", in: blockedUsers).getDocuments { querySnapshot, error in
                if let error = error {
                    print("차단 유저 프로필 불러오기 에러: \(error)")
                } else {
                    for document in querySnapshot!.documents.reversed() {
                        let imageUrl = document.get("imageUrl") as! String
                        let nickname = document.get("nickname") as! String
                        let email = document.get("email") as! String
                        self.imageUrlArr.append(imageUrl)
                        self.nicknameArr.append(nickname)
                        self.emailArr.append(email)
                    }
                    blockedUserHandler(self.imageUrlArr, self.nicknameArr, self.emailArr)
                }
            }
        }
    }
    
    func getImageUrl(imageUrl: String, kfUrlHandler: @escaping (URL) -> ()) {
        guard let url = URL(string: imageUrl) else { return }
        kfUrlHandler(url)
    }
    
    func unblockUser(index: Int, unblockUserHandler: @escaping () -> ()) {
        let email = userdefault.string(forKey: "email")!
        let blockedUsers = userdefault.stringArray(forKey: "blockedUsers")!
        let collection = database.collection("UserDataBase")
        collection.document(email).updateData(["blockedUsers": FieldValue.arrayRemove([blockedUsers[index]])]) { error in
            if let error = error {
                print("유저 차단 에러: \(error)")
            } else {
                print("unblockUser Success")
                // also add in Userdefault
                var blockedUsers = self.userdefault.stringArray(forKey: "blockedUsers")!
                blockedUsers.remove(at: index)
                self.userdefault.set(blockedUsers, forKey: "blockedUsers")
                unblockUserHandler()
            }
        }
    }
    
}
