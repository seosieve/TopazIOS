//
//  TravelNoteViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import Foundation
import Firebase
import FirebaseAuth

class TravelNoteViewModel {
    let userEmail = Auth.auth().currentUser!.email!
    let storage = Storage.storage()
    
    func getUserImage(view:UIImageView) {
        let imageRef = storage.reference(withPath: "UserProfileImages/\(userEmail).png")
        imageRef.getData(maxSize: 1*300*300) { data, error in
            if let error = error {
                print("프로필 이미지 다운로드 에러 : \(error)")
            } else {
                let image = UIImage(data: data!)
                view.image = image
            }
        }
    }
}
