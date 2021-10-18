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
                    let imageUrl = document.get("imageUrl") as! [String]
                    let tailText = document.get("tailText") as! String
                    let likes = document.get("likes") as! Int
                    let views = document.get("views") as! Int
                    
                    let article = Article(articleID: articleID, auther: auther, autherEmail: autherEmail, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, imageUrl: imageUrl, tailText: tailText, likes: likes, views: views)
                    
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
                    print("글 이미지 다운로드 에러 : \(error)")
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
    
    func deleteExperienceImage(articleID: String, index: Int) {
        let imageRef = self.storage.reference(withPath: "Articles/\(articleID)/\(index).png")
        imageRef.delete { error in
            if let error = error {
                print("글 이미지 삭제 에러 : \(error)")
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
                print("글 삭제 에러 : \(error)")
            } else {
                print("deleteArticle Success")
                deleteArticleHandler()
            }
        }
    }
}
