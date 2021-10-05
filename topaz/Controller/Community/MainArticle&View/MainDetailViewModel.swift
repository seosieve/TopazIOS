//
//  MainDetailViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/28.
//

import Foundation
import Firebase

class MainDetailViewModel {
    let storage = Storage.storage()
    let database = Firestore.firestore()
    var email = UserDefaults.standard.string(forKey: "email")!
    
    func isClickedLikes(currentID: String, likesHandler: @escaping (Bool) -> ()) {
        let collection = database.collection("UserDataBase")
        collection.document(email).getDocument { document, error in
            if let error = error {
                print("likes 목록 탐색 에러: \(error)")
            } else {
                let likedPosts = document!.get("likedPosts") as! [String]
                if likedPosts.contains(currentID) {
                    likesHandler(true)
                } else {
                    likesHandler(false)
                }
            }
        }
    }
    
    func getUserImage(email: String, getImageHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            let imageRef = self.storage.reference(withPath: "UserProfileImages/\(email).png")
            imageRef.getData(maxSize: 24*100*100) { data, error in
                if let error = error {
                    print("프로필 이미지 다운로드 에러 : \(error)")
                    let image = UIImage(named: "DefaultUserImage")!
                    DispatchQueue.main.async {
                        getImageHandler(image)
                    }
                } else {
                    if let data = data {
                        let image = UIImage(data: data)!
                        DispatchQueue.main.async {
                            getImageHandler(image)
                        }
                    }
                }
            }
        }
    }
    
    func increaseViews(currentID: String) {
        let collection = database.collection("Articles")
        collection.document(currentID).updateData(["views" : FieldValue.increment(1.0)]) { error in
            if let error = error {
                print("views 업데이트 에러: \(error)")
            }
        }
    }
    
    func increaseLikes(currentID: String, isIncrease: Bool) {
        if isIncrease {
            database.collection("UserDataBase").document(email).updateData(["likedPosts" : FieldValue.arrayUnion([currentID])]) { error in
                if let error = error {
                    print("likedPosts 추가 에러: \(error)")
                }
            }
            database.collection("Articles").document(currentID).updateData(["likes" : FieldValue.increment(1.0)]) { error in
                if let error = error {
                    print("likes 업데이트 에러: \(error)")
                }
            }
        } else {
            database.collection("UserDataBase").document(email).updateData(["likedPosts" : FieldValue.arrayRemove([currentID])]) { error in
                if let error = error {
                    print("likedPosts 삭제 에러: \(error)")
                }
            }
            database.collection("Articles").document(currentID).updateData(["likes" : FieldValue.increment(-1.0)]) { error in
                if let error = error {
                    print("likes 업데이트 에러: \(error)")
                }
            }
        }
    }
    
    func getExperienceImage(articleID: String, index: Int, getImageHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            let imageRef = self.storage.reference(withPath: "Articles/\(articleID)/\(index).png")
            imageRef.getData(maxSize: 8*500*500) { data, error in
                if let error = error {
                    print("프로필 이미지 다운로드 에러 : \(error)")
                } else {
                    if let data = data {
                        let image = UIImage(data: data)!
                        DispatchQueue.main.async {
                            getImageHandler(image)
                        }
                    }
                }
            }
        }
    }
    
    
}
