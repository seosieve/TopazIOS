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
    
    func addUserInfo(_ email: String, _ uid: String, _ nickname: String, _ introduce: String) {
        collection.document(email)
            .setData(["email": email, "uid": uid, "nickname": nickname, "introduce": introduce]) { error in
            if let error = error {
                print("Error saving user data : \(error)")
            }
        }
    }
    
    func addUserImage(userEmail: String, data: Data) {
        let imageRef = storage.reference().child("UserProfileImages/\(userEmail).png")
        imageRef.putData(data, metadata: nil) {
            _, error in
            if let error = error {
                print("프로필 사진 저장 에러 : \(error)")
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
