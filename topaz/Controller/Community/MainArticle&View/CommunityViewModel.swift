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
    var articleArr = [Article]()

    func getArticle(articleHandler: @escaping ([Article]) -> ()) {
        articleArr = []
        db.order(by: "writtenDate", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("글 불러오기 에러 : \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let articleID = document.get("articleID") as! String
                    let auther = document.get("auther") as! String
                    let writtenDate = document.get("writtenDate") as! Double
                    let strWrittenDate = document.get("strWrittenDate") as! String
                    let country = document.get("country") as! [String]
                    let title = document.get("title") as! String
                    let mainText = document.get("mainText") as! String
                    let likes = document.get("likes") as! Int
                    let views = document.get("views") as! Int
                    
                    let article = Article(articleID: articleID, auther: auther, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, likes: likes, views: views)
                    self.articleArr.append(article)
                    articleHandler(self.articleArr)
                }
                
            }
        }
    }
}

