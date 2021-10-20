//
//  ReportViewModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/19.
//

import Foundation
import Firebase

class ReportViewModel {
    let database = Firestore.firestore()
    let userdefault = UserDefaults.standard
    
    func makeDate() -> String {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy. MM. dd"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func makeReportDetail(reportText: String) -> String {
        let spaceholder = "신고 사유에 대한 세부 내용을 적어주세요. (200자 제한)"
        let reportTextOutput = (reportText == spaceholder ? "" : reportText)
        return reportTextOutput
    }
    
    func addReport(articleID: String, auther: String, autherEmail: String, reportReason: [String], reportDetailStr: String, addReportHandler: @escaping () -> ()) {
        let collection = database.collection("Reports")
        let reportUser = userdefault.string(forKey: "nickname")!
        let reportDetail = makeReportDetail(reportText: reportDetailStr)
        let reportDate = makeDate()
        let report = Report(articleID: articleID, auther: auther, autherEmail: autherEmail, reportUser: reportUser, reportReason: reportReason, reportDetail: reportDetail, reportDate: reportDate)
        collection.document().setData(report.dicDataType) { error in
            if let error = error {
                print("Report 저장 에러 : \(error)")
            } else {
                addReportHandler()
            }
        }
    }
    
}
