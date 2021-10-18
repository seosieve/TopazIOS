//
//  UserModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/18.
//

import Foundation

struct User {
    let email: String
    let nickname: String
    let introduce: String
    let imageUrl: String
    let likedPosts: [String]
    let friends: [String]
    let exp: Int
    let collectibles: [String]
    let topazAlbumUrl: [String]
    
    // [String:Any] 타입으로 변환
    var dicDataType: [String: Any] {
        return ["email": email, "nickname": nickname, "introduce": introduce, "imageUrl": imageUrl, "likedPosts": likedPosts, "friends": friends, "exp": exp, "collectibles": collectibles, "topazAlbumUrl": topazAlbumUrl]
    }
}
