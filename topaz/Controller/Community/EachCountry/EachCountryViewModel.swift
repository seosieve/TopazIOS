//
//  EachCountryViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/20.
//

import Foundation
import Firebase

class EachCountryViewModel {
    let database = Firestore.firestore()
    var tableArticleArr = [Article]()
    
    func getHitArticle(country: String, hitArticleHandler: @escaping (Article) -> ()) {
        let collection = database.collection("Articles")
        collection.whereField("country", arrayContainsAny: [country]).order(by: "likes", descending: true).limit(to: 1).getDocuments { querySnapshot, error in
            if let error = error {
                print("힛갤 불러오기 에러 : \(error)")
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
                    let imageName = document.get("imageName") as! [Int]
                    let imageUrl = document.get("imageUrl") as! [String]
                    let tailText = document.get("tailText") as! String
                    let likes = document.get("likes") as! Int
                    let views = document.get("views") as! Int
                    
                    let article = Article(articleID: articleID, auther: auther, autherEmail: autherEmail, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, imageName: imageName, imageUrl: imageUrl, tailText: tailText, likes: likes, views: views)
                    hitArticleHandler(article)
                }
            }
        }
    }
    
    func getEachArticle(country: String, eachArticleHandler: @escaping ([Article]) -> ()) {
        tableArticleArr = []
        let collection = database.collection("Articles")
        collection.whereField("country", arrayContainsAny: [country]).order(by: "writtenDate").getDocuments { querySnapshot, error in
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
                    let imageName = document.get("imageName") as! [Int]
                    let imageUrl = document.get("imageUrl") as! [String]
                    let tailText = document.get("tailText") as! String
                    let likes = document.get("likes") as! Int
                    let views = document.get("views") as! Int
                    
                    let article = Article(articleID: articleID, auther: auther, autherEmail: autherEmail, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, imageName: imageName, imageUrl: imageUrl, tailText: tailText, likes: likes, views: views)
                    self.tableArticleArr.append(article)
                }
                eachArticleHandler(self.tableArticleArr)
            }
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
