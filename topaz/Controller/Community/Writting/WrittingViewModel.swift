//
//  WrittingViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/16.
//

import Foundation
import Firebase

class WrittingViewModel {
    
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
        let document = Firestore.firestore().collection("Articles").document()
        let articleID = document.documentID
        let nickname = UserDefaults.standard.string(forKey: "nickname")!
        let writtenDate = NSDate().timeIntervalSince1970
        let strWrittenDate = makeDate()
        let title = title.text ?? ""
        let mainText = mainText.text ?? ""
        let country = country
        
        let article = Article(articleID: articleID, auther: nickname, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, likes: 0, views: 0)
        document.setData(<#T##documentData: [String : Any]##[String : Any]#>)
        
        makeArticleHandler(article)
    }

    func addArticle(_ article: Article, addArticleHandler: @escaping () -> ()) {
        let collection = Firestore.firestore().collection("Articles")
        collection.document(article)
        collection.addDocument(data: article.dicDataType) {error in
            if let error = error {
                print("FireStore 저장 에러 : \(error)")
            } else {
                print("FireStore 저장 성공")
                addArticleHandler()
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        let screenScale = UIScreen.main.scale // 화면 @레티나에 따라 조정
        let scaleWidth = screenScale * newWidth
        let scaleHeight = screenScale * newHeight
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
