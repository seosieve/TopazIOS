//
//  ReportModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/19.
//

import Foundation

struct Report {
    let articleID: String
    let auther: String
    let autherEmail: String
    let reportUser: String
    let reportReason: [String]
    let reportDetail: String
    let reportDate: String
    
    // [String:Any] 타입으로 변환
    var dicDataType: [String: Any] {
        return ["articleID": articleID, "auther": auther, "autherEmail": autherEmail, "reportUser": reportUser, "reportReason": reportReason, "reportDetail": reportDetail, "reportDate": reportDate]
    }
}

let reportReasonBundle = ["부적절한 게시물", "게시글 도배", "부적절한 닉네임", "욕설 및 과격한 언어 사용", "특정 인물 및 사상 비하 / 비방", "음란물", "타 글 표절", "게시글 목적의 불건전성", "홍보 목적의 게시글"]
