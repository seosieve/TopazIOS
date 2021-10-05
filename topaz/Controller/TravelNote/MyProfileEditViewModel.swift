//
//  MyProfileEditViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/23.
//

import Foundation
import Firebase

class MyProfileEditViewModel {
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    func getUserImage(email: String, getImageHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            let imageRef = self.storage.reference(withPath: "UserProfileImages/\(email).png")
            imageRef.getData(maxSize: 4*350*350) { data, error in
                if let error = error {
                    print("프로필 이미지 다운로드 에러 : \(error)")
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
    
    func isNicknameValid(_ nickname: String?) -> Bool {
        let nicknameReg = "^[가-힣]{1,4}$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameReg)
        return nicknameTest.evaluate(with: nickname)
    }
    
    func isExist(nickname: String, nicknameHandler: @escaping () -> ()) {
        let collection = database.collection("UserDataBase")
        collection.whereField("nickname", isEqualTo: nickname).getDocuments { querySnapshot, error in
            if let error = error {
                print("닉네임 탐색 에러 : \(error)")
            } else {
                if querySnapshot!.documents.count != 0 {
                    nicknameHandler()
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        let screenScale = UIScreen.main.scale // 화면 @레티나에 따라 조정
        print(screenScale)
        let scaleWidth = screenScale * newWidth
        let scaleHeight = screenScale * newHeight
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func addUserInfo(_ email: String, _ nickname: String, _ introduce: String, addInfoHandler: @escaping () -> ()) {
        let collection = database.collection("UserDataBase")
        collection.document(email)
            .setData(["nickname": nickname, "introduce": introduce], merge: true) { error in
            if let error = error {
                print("Error saving user data : \(error)")
            } else {
                addInfoHandler()
            }
        }
    }
    
    func searchArticle(_ originalNickname: String, _ changedNickname: String, searchArticleHandler: @escaping ([String], String) -> ()) {
        let collection = database.collection("Articles")
        var IDArray = [String]()
        
        collection.whereField("auther", isEqualTo: originalNickname).getDocuments { querySnapshot, error in
            if let error = error {
                print("Article 탐색 에러 : \(error)")
            } else {
                for document in querySnapshot!.documents {
                    IDArray.append(document.get("articleID") as! String)
                    
                }
                searchArticleHandler(IDArray, changedNickname)
            }
        }
    }
    
    func replaceAuth(IDArray: [String], nickname: String, replaceAuthHandler: @escaping () -> ()) {
        let collection = database.collection("Articles")
        for articleID in IDArray {
            collection.document(articleID).updateData(["auther" : nickname]) { error in
                if let error = error {
                    print("글쓴이 변경 에러: \(error)")
                }
            }
        }
        replaceAuthHandler()
    }
    
    
    
    
    
    func addUserImage(userEmail: String, data: Data, addImageHandler: @escaping () -> ()) {
        let imageRef = storage.reference().child("UserProfileImages/\(userEmail).png")
        imageRef.putData(data, metadata: nil) {
            _, error in
            if let error = error {
                print("프로필 사진 저장 에러 : \(error)")
            } else {
                addImageHandler()
            }
        }
    }
}
