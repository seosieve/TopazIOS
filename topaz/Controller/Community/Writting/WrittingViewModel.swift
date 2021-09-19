//
//  WrittingViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/16.
//

import Foundation
import Firebase

class WrittingViewModel {
    let collection = Firestore.firestore().collection("Articles")
    
    func makeCountry(country1: UIButton, country2: UIButton, country3: UIButton) -> [String] {
        var countryArr = [String]()
        if let country1 = country1.currentTitle {
            countryArr.append(country1)
            if let country2 = country2.currentTitle {
                countryArr.append(country2)
                if let country3 = country3.currentTitle {
                    countryArr.append(country3)
                }
            }
        }
        return countryArr
    }
    
    func makeDate() -> String {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func makeArticle(country: [String],title: UITextView, mainText: UITextView, makeArticleHandler: @escaping (Article) -> ()) {
        let collection = Firestore.firestore().collection("UserDataBase")
        let email = Auth.auth().currentUser!.email!
        let writtenDate = NSDate().timeIntervalSince1970
        let strWrittenDate = makeDate()
        let title = title.text ?? ""
        let mainText = mainText.text ?? ""
        let country = country
        
        collection.document(email).getDocument { document, error in
            if let error = error {
                print("닉네임 불러오기 에러: \(error)")
            } else {
                if let document = document {
                    let nickname = document.get("nickname") as! String
                    let article = Article(auther: nickname, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, likes: 0, views: 0)
                    makeArticleHandler(article)
                } else {
                    if let error = error {
                        print("유저 닉네임 필드 에러: \(error)")
                    }
                }
            }
        }
    }

    func addArticle(_ article: Article, addArticleHandler: @escaping () -> ()) {
        collection.addDocument(data: article.dicDataType) {error in
            if let error = error {
                print("FireStore 저장 에러 : \(error)")
            } else {
                print("FireStore 저장 성공")
                addArticleHandler()
            }
        }
    }
}
