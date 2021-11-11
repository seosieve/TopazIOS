//
//  EditProfileViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/01.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit

class EditProfileViewModel {
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
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
    
    func createUser(email: String, password: String, createUserHandler: @escaping () -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!)
            } else {
                createUserHandler()
            }
        }
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
    
    func addUserInfo(_ email: String, _ nickname: String, _ introduce: String, addInfoHandler: @escaping () -> ()) {
        let strDate = [makeDate()]
        let user = User(email: email, nickname: nickname, introduce: introduce, imageUrl: "", likedPosts: [String](), friends: [String](), blockedUsers: [String](), exp: 0, albumName: ["토파즈와 시작한 첫 여행"], albumUrl: [String](), albumDate: strDate, ticketName: ["TO-PAZ"], ticketDate: strDate, collectibles: [String]())
        let collection = database.collection("UserDataBase")
        collection.document(email).setData(user.dicDataType) { error in
            if let error = error {
                print("Error saving user data : \(error)")
            } else {
                addInfoHandler()
            }
        }
    }
    
    func addAlbumImage(email: String, addUserImageHandler: @escaping () -> ()) {
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let imageRef = storage.reference().child("AlbumImages/\(email)/\(timeStamp).png")
        let data = UIImage(named: "FirstAlbumImage")!.pngData()!
        imageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("프로필 사진 저장 에러 : \(error)")
            } else {
                imageRef.downloadURL { url, error in
                    guard let url = url else { return }
                    self.addAlbumUrl(email: email, url: url)
                    addUserImageHandler()
                }
            }
        }
    }
    
    func addAlbumUrl(email: String, url: URL) {
        let urlString = "\(url)"
        let document = database.collection("UserDataBase").document(email)
        document.updateData(["albumUrl": [urlString]])
    }
    
    func addUserImage(email: String, image: UIImage, addUserImageHandler: @escaping () -> ()) {
        let imageRef = storage.reference().child("UserProfileImages/\(email).png")
        let data = image.pngData()!
        imageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("프로필 사진 저장 에러 : \(error)")
            } else {
                imageRef.downloadURL { url, error in
                    guard let url = url else { return }
                    self.addImageUrl(email: email, url: url)
                    addUserImageHandler()
                }
            }
        }
    }
    
    func addImageUrl(email: String, url: URL) {
        let urlString = "\(url)"
        let document = database.collection("UserDataBase").document(email)
        document.updateData(["imageUrl": urlString])
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
}
