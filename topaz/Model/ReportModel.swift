//
//  ReportModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/19.
//

import Foundation

struct Report {
    let reportReason: String
    let reportDetail: String
    
    // [String:Any] 타입으로 변환
    var dicDataType: [String: Any] {
        return ["reportReason": reportReason]
    }
    
//
//    // [String:Any] 타입으로 변환
//    var dicDataType: [String: Any] {
//        return ["email": email, "nickname": nickname, "introduce": introduce, "imageUrl": imageUrl, "likedPosts": likedPosts, "friends": friends, "exp": exp, "collectibles": collectibles, "topazAlbumUrl": topazAlbumUrl]
//    }
}

let reportReasonBundle = ["부적절한 게시물", "게시글 도배", "부적절한 닉네임", "욕설 및 과격한 언어 사용", "특정 인물 및 사상 비하 / 비방", "음란물", "타 글 표절", "게시글 목적의 불건전성", "홍보 목적의 게시글"]
