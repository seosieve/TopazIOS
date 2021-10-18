//
//  ModifyViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/13.
//

import Foundation
import Firebase

class ModifyViewModel {
    let collection = Firestore.firestore().collection("Articles")
    
    func makeCountry(_ countryButton: [UIButton]) -> [String] {
        var countryArr = [String]()
        for country in countryButton {
            if let countryName = country.currentTitle {
                countryArr.append(countryName)
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
    
    
    func modifyArticle(articleID: String, country: [String], title: UITextView, mainText: UITextView, imageText: [String], tailText: String, likes: Int, views: Int, modifyArticleHandler: @escaping (String) -> ()) {
        let document = collection.document(articleID)
        
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
        
        let article = Article(articleID: articleID, auther: nickname, autherEmail: email, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, imageUrl: imageUrl ,tailText: tailText, likes: likes, views: views)
        document.setData(article.dicDataType){ error in
            if let error = error {
                print("FireStore 저장 에러 : \(error)")
            } else {
                modifyArticleHandler(articleID)
            }
        }
    }
    
    func modifyExperienceImage(articleID: String, image: UIImage, index: Int, modifyExperienceImageHandler: @escaping (URL) -> ()) {
        let reference = Storage.storage().reference()
            let imageRef = reference.child("Articles/\(articleID)/\(index).png")
            let data = image.pngData()
            imageRef.putData(data!, metadata: nil) { _, error in
                if let error = error {
                    print("프로필 사진 저장 에러 : \(error)")
                } else {
                    imageRef.downloadURL { url, error in
                        guard let url = url else { return }
                        modifyExperienceImageHandler(url)
                    }
                }
            }
    }
    
    func modifyImageUrl(articleID: String, url: URL, modifyImageUrlHandler: @escaping () -> ()) {
        let urlString = "\(url)"
        let document = collection.document(articleID)
        document.updateData(["imageUrl" : FieldValue.arrayUnion([urlString])])
        modifyImageUrlHandler()
    }
}

