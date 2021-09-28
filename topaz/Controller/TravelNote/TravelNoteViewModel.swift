//
//  TravelNoteViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import Foundation
import Firebase

class TravelNoteViewModel {
    let storage = Storage.storage()
    
    func getUserImage(email: String, getImageHandler: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            let imageRef = self.storage.reference(withPath: "UserProfileImages/\(email).png")
            imageRef.getData(maxSize: 2*300*300) { data, error in
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
}
