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
    let blockedUsers: [String]
    let exp: Int
    let albumName: [String]
    let albumUrl: [String]
    let albumDate: [String]
    let ticketName: [String]
    let ticketDate: [String]
    let collectibles: [String]
    
    // [String:Any] 타입으로 변환
    var dicDataType: [String: Any] {
        return ["email": email, "nickname": nickname, "introduce": introduce, "imageUrl": imageUrl, "likedPosts": likedPosts, "friends": friends, "blockedUsers": blockedUsers, "exp": exp, "albumName": albumName, "albumUrl": albumUrl, "albumDate": albumDate, "ticketName": ticketName, "ticketDate": ticketDate, "collectibles": collectibles]
    }
}
