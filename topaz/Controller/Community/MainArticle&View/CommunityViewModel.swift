//
//  CommunityViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import Foundation
import Firebase

class CommunityViewModel {
    let db = Firestore.firestore().collection("Articles")
    let articleUrl = "gs://topaz-a6a66.appspot.com/Articles"
    var collectionArticleArr = [Article]()
    var tableArticleArr = [Article]()
    
    func getCollectionArticle(articleHandler: @escaping ([Article]) -> ()) {
        collectionArticleArr = []
        var articleArr = [Article]()
        let dateBound = NSDate().timeIntervalSince1970 - 604800
        db.whereField("writtenDate", isGreaterThan: dateBound).getDocuments { querySnapshot, error in
            if let error = error {
                print("글 불러오기 에러 : \(error)")
            } else {
                for document in querySnapshot!.documents {
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
                    articleArr.append(article)
                }
            }
            articleArr.sort{$0.likes > $1.likes}
            if articleArr.count < 5 {
                for index in 0...articleArr.count-1 {
                    self.collectionArticleArr.append(articleArr[index])
                }
                articleHandler(self.collectionArticleArr)
            } else {
                for index in 0...4 {
                    self.collectionArticleArr.append(articleArr[index])
                }
                articleHandler(self.collectionArticleArr)
            }
        }
    }

    func getTableArticle(sortMethod: String, articleHandler: @escaping ([Article]) -> ()) {
        tableArticleArr = []
        let convertedSortMethod = convertSortMethod(sortMethod: sortMethod)
        db.order(by: convertedSortMethod).getDocuments { querySnapshot, error in
            if let error = error {
                print("글 불러오기 에러 : \(error)")
            } else {
                for document in querySnapshot!.documents.reversed() {
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
                    self.tableArticleArr.append(article)
                }
                articleHandler(self.tableArticleArr)
            }
        }
    }
    
    func convertSortMethod(sortMethod: String) -> String {
        switch sortMethod {
        case "조회수순":
            return "views"
        case "좋아요순":
            return "likes"
        case "업로드순":
            return "writtenDate"
        default:
            return "writtenDate"
        }
    }

    func getImageUrl(imageUrl: [String], kfUrlHandler: @escaping (URL?) -> ()) {
        if imageUrl.isEmpty {
            kfUrlHandler(nil)
        } else {
            guard let url = URL(string: imageUrl[0]) else { return }
            kfUrlHandler(url)
        }
        
        
    }
}

