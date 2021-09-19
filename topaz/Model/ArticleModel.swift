//
//  ArticleModel.swift
//  topaz
//
//  Created by 서충원 on 2021/09/16.
//

import Foundation

struct Article {
    let auther: String
    let writtenDate: Double
    let strWrittenDate: String
    let country: [String]
    let title: String
    let mainText: String
    let likes: Int
    let views: Int
    
    init(auther: String = "", writtenDate: Double = 0.0, strWrittenDate: String = "", country: [String] = [String](), title: String = "", mainText: String = "", likes: Int = 0, views: Int = 0) {
        self.auther = auther
        self.writtenDate = writtenDate
        self.strWrittenDate = strWrittenDate
        self.country = country
        self.title = title
        self.mainText = mainText
        self.likes = likes
        self.views = views
    }
    
    // [String:Any] 타입으로 변환
    var dicDataType: [String: Any] {
        return ["auther": auther, "writtenDate": writtenDate, "strWrittenDate": strWrittenDate, "country": country, "title": title, "mainText": mainText, "likes": likes, "views": views]
    }
}
