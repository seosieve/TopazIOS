//
//  ArticleModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/16.
//

import Foundation

struct Article {
    let articleID: String
    let auther: String
    let autherEmail: String
    let writtenDate: Double
    let strWrittenDate: String
    let country: [String]
    let title: String
    let mainText: String
    let imageText: [String]
    let tailText: String
    let likes: Int
    let views: Int
    
    // [String:Any] 타입으로 변환
    var dicDataType: [String: Any] {
        return ["articleID": articleID, "auther": auther, "autherEmail": autherEmail, "writtenDate": writtenDate, "strWrittenDate": strWrittenDate, "country": country, "title": title, "mainText": mainText, "imageText": imageText, "tailText": tailText, "likes": likes, "views": views]
    }
}
