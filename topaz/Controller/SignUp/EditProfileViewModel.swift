//
//  EditProfileViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/01.
//

import Foundation
import Firebase
import FirebaseFirestore

class EditProfileViewModel {
    
    let collection = Firestore.firestore().collection("UserDataBase")
    let storage = Storage.storage()
    
    func isNicknameValid(_ nickname: String?) -> Bool {
        let nicknameReg = "^[가-힣]{1,4}$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameReg)
        return nicknameTest.evaluate(with: nickname)
    }
    
    func isExist(nickname: String, nicknameHandler: @escaping () -> ()) {
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
    
    func addUserInfo(_ email: String, _ nickname: String, _ introduce: String, addInfoHandler: @escaping () -> ()) {
        collection.document(email)
            .setData(["email": email, "nickname": nickname, "introduce": introduce]) { error in
            if let error = error {
                print("Error saving user data : \(error)")
            } else {
                addInfoHandler()
            }
        }
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
