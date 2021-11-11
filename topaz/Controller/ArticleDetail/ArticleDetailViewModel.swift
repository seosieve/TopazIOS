//
//  MainDetailViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/28.
//

import Foundation
import Firebase

class ArticleDetailViewModel {
    let storage = Storage.storage()
    let database = Firestore.firestore()
    let userdefault = UserDefaults.standard
    var email = UserDefaults.standard.string(forKey: "email")!
    
    func getArticle(articleID: String, articleHandler: @escaping (Article) -> ()) {
        let collection = database.collection("Articles")
        collection.document(articleID).getDocument { document, error in
            if let error = error {
                print("글 불러오기 에러 : \(error)")
            } else {
                if let document = document {
                    let articleID = document.get("articleID") as! String
                    let auther = document.get("auther") as! String
                    let autherEmail = document.get("autherEmail") as! String
                    let writtenDate = document.get("writtenDate") as! Double
                    let strWrittenDate = document.get("strWrittenDate") as! String
                    let country = document.get("country") as! [String]
                    let title = document.get("title") as! String
                    let mainText = document.get("mainText") as! String
                    let imageText = document.get("imageText") as! [String]
                    let imageName = document.get("imageName") as! [Int]
                    let imageUrl = document.get("imageUrl") as! [String]
                    let musicName = document.get("musicName") as! [String]
                    let musicVolume = document.get("musicVolume") as! [Float]
                    let tailText = document.get("tailText") as! String
                    let likes = document.get("likes") as! Int
                    let views = document.get("views") as! Int
                    
                    let article = Article(articleID: articleID, auther: auther, autherEmail: autherEmail, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, imageName: imageName, imageUrl: imageUrl, musicName: musicName, musicVolume: musicVolume, tailText: tailText, likes: likes, views: views)
                    
                    articleHandler(article)
                }
            }
        }
    }
    
    func isClickedLikes(currentID: String, likesHandler: @escaping (Bool) -> ()) {
        // 유저가 글에 like를 눌렀는지 안눌렀는지 체크
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
    
    func getUserImage(email: String, getImageHandler: @escaping (URL) -> ()) {
        DispatchQueue.global().async {
            let collection = self.database.collection("UserDataBase")
            collection.document(email).getDocument { document, error in
                if let error = error {
                    print("글쓴이 프로필 이미지 다운로드 에러 : \(error)")
                } else {
                    if let document = document {
                        let imageUrl = document.get("imageUrl") as! String
                        let url = URL(string: imageUrl)!
                        getImageHandler(url)
                    }
                }
            }
        }
    }
    
    func increaseViews(currentID: String) {
        // 유저가 처음 글에 들어올 때만 view count + 1
        let collection = database.collection("Articles")
        collection.document(currentID).updateData(["views" : FieldValue.increment(1.0)]) { error in
            if let error = error {
                print("views 업데이트 에러: \(error)")
            }
        }
    }
    
    func increaseLikes(currentID: String, isIncrease: Bool) {
        if isIncrease {
            database.collection("UserDataBase").document(email).updateData(["likedPosts" : FieldValue.arrayUnion([currentID]), "exp" : FieldValue.increment(Int64(1))]) { error in
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
            database.collection("UserDataBase").document(email).updateData(["likedPosts" : FieldValue.arrayRemove([currentID]), "exp" : FieldValue.increment(Int64(-1))]) { error in
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
    
    func deleteExperienceImage(articleID: String, index: Int) {
        let imageRef = self.storage.reference(withPath: "Articles/\(articleID)/\(index).png")
        imageRef.delete { error in
            if let error = error {
                print("글 이미지 삭제 에러: \(error)")
            } else {
                print("deleteExperienceImage Success")
            }
        }
    }
    
    func getImageUrl(url: String, kfUrlHandler: @escaping (URL) -> ()) {
        guard let url = URL(string: url) else { return }
        kfUrlHandler(url)
    }
    
    func deleteArticle(articleID: String, deleteArticleHandler: @escaping () -> ()) {
        let collection = database.collection("Articles")
        collection.document(articleID).delete { error in
            if let error = error {
                print("글 삭제 에러: \(error)")
            } else {
                print("deleteArticle Success")
                deleteArticleHandler()
            }
        }
    }
    
    func blockUser(autherEmail: String, blockUserHandler: @escaping () -> ()) {
        let collection = database.collection("UserDataBase")
        collection.document(email).updateData(["blockedUsers": FieldValue.arrayUnion([autherEmail])]) { error in
            if let error = error {
                print("유저 차단 에러: \(error)")
            } else {
                print("blockUser Success")
                // also add in Userdefault
                var blockedUsers = self.userdefault.stringArray(forKey: "blockedUsers")!
                blockedUsers.append(autherEmail)
                self.userdefault.set(blockedUsers, forKey: "blockedUsers")
                blockUserHandler()
            }
        }
    }
    
    func minusUserExp() {
        let collection = database.collection("UserDataBase")
        collection.document(email).updateData(["exp" : FieldValue.increment(Int64(-5))])
    }
}
