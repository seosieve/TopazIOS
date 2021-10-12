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
        dateFormatter.dateFormat = "yyyy. MM. dd"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func makeImageText(imageText: [String]) -> [String] {
        var imageTextOutput = [String]()
        let spaceholder = "사진에 대한 여행경험을 적어주세요."
        for text in imageText {
            let output = text == spaceholder ? "" : text
            imageTextOutput.append(output)
        }
        return imageTextOutput
    }
    
    func makeTailText(tailText: UITextView) -> String {
        let spaceholder = "당신의 이야기의 끝맺음을 듣고싶어요."
        if tailText.isHidden == true {
            return ""
        } else {
            let tailTextOutput = (tailText.text == spaceholder ? "" : tailText.text!)
            return tailTextOutput
        }
    }
    
//    func addArticle(country: [String], title: UITextView, mainText: UITextView, imageText: [String], tailText: String, makeArticleHandler: @escaping (String) -> ()) {
//        let document = Firestore.firestore().collection("Articles").document()
//        let articleID = document.documentID
//        let nickname = UserDefaults.standard.string(forKey: "nickname")!
//        let email = UserDefaults.standard.string(forKey: "email")!
//        let writtenDate = NSDate().timeIntervalSince1970
//        let strWrittenDate = makeDate()
//        let title = title.text ?? ""
//        let mainText = mainText.text ?? ""
//        let imageText = imageText
//        let tailText = tailText
//        let country = country
//
//        let article = Article(articleID: articleID, auther: nickname, autherEmail: email, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, tailText: tailText, likes: 0, views: 0)
//        document.setData(article.dicDataType){ error in
//            if let error = error {
//                print("FireStore 저장 에러 : \(error)")
//            } else {
//                makeArticleHandler(articleID)
//            }
//        }
//    }
//
//    func addExperienceImage(articleID: String, imageArr: [UIImage], addImageHandler: @escaping () -> ()) {
//        let reference = Storage.storage().reference()
//        for (index, image) in imageArr.enumerated() {
//            let imageRef = reference.child("Articles/\(articleID)/\(index).png")
//            let data = image.pngData()
//            imageRef.putData(data!, metadata: nil) { _, error in
//                if let error = error {
//                    print("프로필 사진 저장 에러 : \(error)")
//                } else {
//                    addImageHandler()
//                }
//            }
//        }
//    }

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
    
    
    func addArticle(document: DocumentReference, articleID: String, country: [String], title: UITextView, mainText: UITextView, imageText: [String], tailText: String, makeArticleHandler: @escaping (String) -> ()) {
        let nickname = UserDefaults.standard.string(forKey: "nickname")!
        let email = UserDefaults.standard.string(forKey: "email")!
        let writtenDate = NSDate().timeIntervalSince1970
        let strWrittenDate = makeDate()
        let title = title.text ?? ""
        let mainText = mainText.text ?? ""
        let imageText = imageText
        let imageUrl = [String]()
        let tailText = tailText
        let country = country
        
        let article = Article(articleID: articleID, auther: nickname, autherEmail: email, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, imageUrl: imageUrl ,tailText: tailText, likes: 0, views: 0)
        document.setData(article.dicDataType){ error in
            if let error = error {
                print("FireStore 저장 에러 : \(error)")
            } else {
                makeArticleHandler(articleID)
            }
        }
    }
    
    func addExperienceImage(articleID: String, image: UIImage, index: Int, addExperienceImageHandler: @escaping (URL) -> ()) {
        let reference = Storage.storage().reference()
            let imageRef = reference.child("Articles/\(articleID)/\(index).png")
            let data = image.pngData()
            imageRef.putData(data!, metadata: nil) { _, error in
                if let error = error {
                    print("프로필 사진 저장 에러 : \(error)")
                } else {
                    imageRef.downloadURL { url, error in
                        guard let url = url else { return }
                        addExperienceImageHandler(url)
                    }
                }
            }
    }
    
    func addImageUrl(articleID: String, url: URL, addImageUrlHandler: @escaping () -> ()) {
        let urlString = "\(url)"
        let document = Firestore.firestore().collection("Articles").document(articleID)
        document.updateData(["imageUrl" : FieldValue.arrayUnion([urlString])])
        addImageUrlHandler()
    }
}
