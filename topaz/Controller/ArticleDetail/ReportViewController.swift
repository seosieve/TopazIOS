//
//  ReportViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/19.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var reportScrollView: UIScrollView!
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var reportTableViewConstraintY: NSLayoutConstraint!
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var reportTextViewBorder: UIView!
    @IBOutlet weak var reportTextViewContainer: UIView!
    @IBOutlet weak var completeButton: UIButton!
    
    var article: Article?
    var reportReasonArr = [String]()
    let viewModel = ReportViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeButton.isEnabled = false
        makeBorder(target: reportTextViewBorder, radius: 12, isFilled: true)
        makeBorder(target: completeButton, radius: 12, isFilled: true)
        makeShadow(target: reportTextViewContainer, height: 5, opacity: 0.1, shadowRadius: 10)
        makeShadow(target: reportTableView, height: 5, opacity: 0.1, shadowRadius: 10)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
        
        reportTableView.register(ReportTableViewCell.nib(), forCellReuseIdentifier: "ReportTableViewCell")
        reportTableView.dataSource = self
        reportTableView.delegate = self
        reportTextView.delegate = self
    }
    
    //touchesBegan을 대신해서 쓰임
    @objc func tabScrollView() {
        reportTextView.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        confirmReportAlert()
    }
    
}

//MARK: - UI Functions
extension ReportViewController {
    func popUpToast() {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "사유는 최대 3개까지 선택할 수 있습니다.", attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func reportCompleteToast() {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "신고가 완료되었습니다. 빠른 시일 내에 검토 후 조치하도록 하겠습니다.", attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func confirmReportAlert() {
        let alert = UIAlertController(title: "신고를 제출할까요?", message: nil, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "아니오", style: .cancel)
        let report = UIAlertAction(title: "예", style: .default) { action in
            self.viewModel.addReport(articleID: self.article!.articleID, auther: self.article!.auther, autherEmail: self.article!.autherEmail, reportReason: self.reportReasonArr, reportDetailStr: self.reportTextView.text) {
                self.reportCompleteToast()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        cancle.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        alert.addAction(cancle)
        alert.addAction(report)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportReasonBundle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if completeButton.isEnabled == false {
            shiftButton(for: completeButton, isOn: true)
        }
        if reportReasonArr.count < 3 {
            let selectedReaseon = reportReasonBundle[indexPath.row]
            reportReasonArr.append(selectedReaseon)
        } else {
            reportTableView.deselectRow(at: indexPath, animated: true)
            popUpToast()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        reportReasonArr = reportReasonArr.filter{$0 != reportReasonBundle[indexPath.row]}
        if reportReasonArr.count == 0 {
            shiftButton(for: completeButton, isOn: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.selectionStyle = .none
        cell.reportText.text = reportReasonBundle[indexPath.row]
        return cell
    }
}

//MARK: - UITextViewDelegate
extension ReportViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 줄바꿈 제한, 본문으로 넘어가기
        if text == "\n" {
            reportTextView.endEditing(true)
        }
        // Title 글자수 제한
        guard let str = reportTextView.text else { return true }
        let length = str.count + text.count - range.length
        return length <= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Gray4") {
            textView.text = nil
            textView.textColor = UIColor(named: "Gray1")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "신고 사유에 대한 세부 내용을 적어주세요. (200자 제한)"
            textView.textColor = UIColor(named: "Gray4")
        }
    }
}
