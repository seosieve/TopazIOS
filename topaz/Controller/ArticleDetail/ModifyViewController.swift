//
//  ModifyViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/13.
//

import UIKit
import Firebase
import Lottie

class ModifyViewController: UIViewController {

    @IBOutlet weak var writtingScrollView: UIScrollView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var countryQuestionButton: UIButton!
    @IBOutlet var countryButton: [UIButton]! {
        didSet {countryButton.sort {$0.tag < $1.tag}}
    }
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var tailTextView: UITextView!
    @IBOutlet weak var addImageTableView: UITableView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addEmojiButton: UIButton!
    
    let viewModel = ModifyViewModel()
    private let imagePicker = UIImagePickerController()
    
    let backgroundView = UIView()
    let lottieView = AnimationView(name: "Loading")
    
    var article: Article?
    var selectedCountryArr = [String]()
    var imageArr = [UIImage]()
    var textArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircle(target: registerButton, color: "MintBlue", width: 0)
        makeCircle(target: addImageButton, color: "MintBlue", width: 0)
        makeCircle(target: addEmojiButton, color: "MintBlue", width: 0)
        makeShadow(target: addImageButton, radius: addImageButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        makeShadow(target: addEmojiButton, radius: addEmojiButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        writtingScrollView.addGestureRecognizer(tapGestureReconizer)
        
//        titleTextView.delegate = self
//        mainTextView.delegate = self
//        tailTextView.delegate = self
//
//        addImageTableView.register(AddImageTableViewCell.nib(), forCellReuseIdentifier: "AddImageTableViewCell")
//        addImageTableView.delegate = self
//        addImageTableView.dataSource = self
        
//        imagePicker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setCountryButton()
    }
    
    //touchesBegan을 대신해서 쓰임
    @objc func tabScrollView() {
        titleTextView.endEditing(true)
        mainTextView.endEditing(true)
        tailTextView.endEditing(true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
//
//    @IBAction func registerButtonPressed(_ sender: UIButton) {
//        let countryArr = viewModel.makeCountry(countryButton)
//        // 실패일 때 ToastMessage
//        if countryArr.count == 0 {
//            popUpToast("어느 나라에 대한 여행경험인가요? 궁금해요.")
//        } else if titleTextView.textColor == UIColor(named: "Gray4") {
//            popUpToast("당신의 여행경험의 제목을 지어주세요.")
//        } else if mainTextView.textColor == UIColor(named: "Gray4") {
//            popUpToast("좀 더 자세한 여행경험을 듣고싶어요!")
//        } else {
//            // 재확인 AlertMessage
//            confirmRegisterAlert()
//        }
//    }
    
    @IBAction func addCountryButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddCountry", sender: sender)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addEmojiButtonPressed(_ sender: UIButton) {
        
    }
}
//
////MARK: - UI Functions
//extension ModifyViewController {
//    func makeArticleModifyUI() {
//        let a = article?.country.count
//    }
//
//    func setCountryButton() {
//        country1.setTitle(countryName1, for: .normal)
//        country2.setTitle(countryName2, for: .normal)
//        country3.setTitle(countryName3, for: .normal)
//        let width1 = countryName1 != nil ? 1 : 0
//        let width2 = countryName2 != nil ? 1 : 0
//        let width3 = countryName3 != nil ? 1 : 0
//        makeCircle(target: country1, color: "MintBlue", width: width1)
//        makeCircle(target: country2, color: "MintBlue", width: width2)
//        makeCircle(target: country3, color: "MintBlue", width: width3)
//        if countryName1 == nil && countryName2 == nil && countryName3 == nil {
//            countryQuestionButton.isHidden = false
//        } else {
//            countryQuestionButton.isHidden = true
//        }
//    }
//
//}
//
//
////MARK: - UITextViewDelegate
//extension ModifyViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        switch textView {
//        case titleTextView:
//            // 줄바꿈 제한, 본문으로 넘어가기
//            if text == "\n" {
//                mainTextView.becomeFirstResponder()
//            }
//            // Title 글자수 제한
//            guard let str = titleTextView.text else { return true }
//            let length = str.count + text.count - range.length
//            return length <= 31
//        default:
//            // Title 글자수 제한
//            guard let str = textView.text else { return true }
//            let length = str.count + text.count - range.length
//            return length <= 2000
//        }
//    }
//
//    // TextView Line에 따라 동적 height조절
//    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: view.frame.width-40, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//
//        textView.constraints.forEach { constraint in
//            if constraint.firstAttribute == .height {
//                constraint.constant = estimatedSize.height
//            }
//        }
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor(named: "Gray4") {
//            switch textView {
//            case titleTextView:
//                textView.text = nil
//                textView.textColor = UIColor(named: "Gray1")
//                textView.font = UIFont(name: "NotoSansKR-Bold", size: 24)
//            default:
//                textView.text = nil
//                textView.textColor = UIColor(named: "Gray2")
//            }
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            switch textView {
//            case titleTextView:
//                textView.text = "제목을 입력해주세요."
//                textView.textColor = UIColor(named: "Gray4")
//                textView.font = UIFont(name: "NotoSansKR-Regular", size: 24)
//            case mainTextView:
//                textView.text = "당신이 다녀왔던 생생한 여행경험은 무엇인가요?"
//                textView.textColor = UIColor(named: "Gray4")
//            default:
//                textView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
//                textView.textColor = UIColor(named: "Gray4")
//            }
//        }
//    }
//}
//
////MARK: - UITableViewDelegate, UITableViewDataSource
//extension ModifyViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return imageArr.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath) as! AddImageTableViewCell
//        cell.selectionStyle = .none
//        makeBorder(target: cell.experienceTextViewBorder, radius: 12, isFilled: true)
//        cell.experienceImage.image = imageArr[indexPath.row]
//        cell.experienceTextView.text = textArr[indexPath.row]
//        // Image 지웠을 때 기존 cell색 따라가는 이슈 대응
//        if cell.experienceTextView.text == "사진에 대한 여행경험을 적어주세요." {
//            cell.experienceTextView.textColor = UIColor(named: "Gray4")
//        } else {
//            cell.experienceTextView.textColor = UIColor(named: "Gray2")
//        }
//
//        cell.index = indexPath.row
//        makeBorder(target: cell.experienceImage, radius: 12, color: "Gray6", isFilled: false)
//        //삭제 델리게이트 설정
//        cell.delegate = self
//
//        cell.textChanged {[weak tableView, weak self] newText in
//            self?.textArr[indexPath.row] = newText
//            print(self!.textArr[indexPath.row])
//            DispatchQueue.main.async {
//                tableView?.beginUpdates()
//                self?.makeTableViewHeight()
//                tableView?.endUpdates()
//            }
//        }
//        return cell
//    }
//}
