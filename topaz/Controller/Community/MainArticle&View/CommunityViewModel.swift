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

    func getArticle(sortMethod: String, articleHandler: @escaping ([Article]) -> ()) {
        articleArr = []
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
                    let tailText = document.get("tailText") as! String
                    let likes = document.get("likes") as! Int
                    let views = document.get("views") as! Int
                    
                    let article = Article(articleID: articleID, auther: auther, autherEmail: autherEmail, writtenDate: writtenDate, strWrittenDate: strWrittenDate, country: country, title: title, mainText: mainText, imageText: imageText, tailText: tailText, likes: likes, views: views)
                    self.articleArr.append(article)
                }
                articleHandler(self.articleArr)
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
            return "strWrittenDate"
        default:
            return "strWrittenDate"
        }
    }
    
    func getArticleImage(articleID: String, imageText: [String], getImageHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            let storage = Storage.storage()
            let imageRef = storage.reference(withPath: "Articles/\(articleID)/\(0).png")
            if imageText.count == 0 {
                let image = UIImage(named: "aa")!
                DispatchQueue.main.async {
                    getImageHandler(image)
                }
            } else {
                imageRef.getData(maxSize: 8*500*500) { data, error in
                    if let error = error {
                        print("프로필 이미지 다운로드 에러 : \(error)")
                    } else {
                        if let data = data {
                            let image = UIImage(data: data)!
                            let resizeImage = self.resizeImage(image: image, newWidth: 44)
                            DispatchQueue.main.async {
                                getImageHandler(resizeImage)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        let screenScale = 2.0 // 화면 @레티나에 따라 조정
        let scaleWidth = screenScale * newWidth
        let scaleHeight = screenScale * newHeight
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

