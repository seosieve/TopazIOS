//
//  WrittingViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import UIKit
import Firebase

class WrittingViewController: UIViewController {

    @IBOutlet weak var writtingScrollView: UIScrollView!
    @IBOutlet weak var resisterButton: UIButton!
    @IBOutlet weak var countryQuestionButton: UIButton!
    @IBOutlet weak var country1: UIButton!
    @IBOutlet weak var country2: UIButton!
    @IBOutlet weak var country3: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var tailTextView: UITextView!
    @IBOutlet weak var addImageTableView: UITableView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addEmojiButton: UIButton!
    
    let viewModel = WrittingViewModel()
    private let imagePicker = UIImagePickerController()
    
    var countryName1: String!
    var countryName2: String!
    var countryName3: String!
    var imageArr = [UIImage]()
    var textArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeCircle(target: resisterButton, color: "MintBlue", width: 0)
        makeCircle(target: addImageButton, color: "MintBlue", width: 0)
        makeCircle(target: addEmojiButton, color: "MintBlue", width: 0)
        makeShadow(target: addImageButton, radius: addImageButton.frame.size.height/2)
        makeShadow(target: addEmojiButton, radius: addImageButton.frame.size.height/2)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        writtingScrollView.addGestureRecognizer(tapGestureReconizer)
        
        titleTextView.delegate = self
        mainTextView.delegate = self
        tailTextView.delegate = self
        
        addImageTableView.register(AddImageTableViewCell.nib(), forCellReuseIdentifier: "AddImageTableViewCell")
        addImageTableView.delegate = self
        addImageTableView.dataSource = self
        
        imagePicker.delegate = self
        
        placeholderSetting()
        makeTableViewHeight()
        tailTextView.isHidden = true
    }
    
    // 다녀온 나라 정보값 받아오기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCountryButton()
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
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let countryArr = viewModel.makeCountry(country1:country1, country2:country2, country3:country3)
        if countryArr.count == 0 {
            popUpToast("어느 나라에 대한 여행경험인가요? 궁금해요.")
        } else if titleTextView.textColor == UIColor(named: "Gray4") {
            popUpToast("당신의 여행경험의 제목을 지어주세요.")
        } else if mainTextView.textColor == UIColor(named: "Gray4") {
            popUpToast("좀 더 자세한 여행경험을 듣고싶어요!.")
        } else {
            viewModel.makeArticle(country: countryArr, title: titleTextView, mainText: mainTextView) { article in
//                현재 비동기 처리 안됨. 어짜피 이미지 포함 토스트 하나 더 넣을꺼니까 거기다가 저장
//                self.popUpToast("당신의 소중한 경험이 저장되었습니다!")
                self.viewModel.addArticle(article) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addCountryButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddCountry", sender: sender)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "삽입할 이미지를 선택해주세요", message: "앨범에서 선택 또는 카메라 사용이 가능합니다.", preferredStyle: .actionSheet)
        let album = UIAlertAction(title: "앨범에서 선택", style: .default) { (action) in
            self.useLibrary()
        }
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { (action) in
            self.useCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addImojiButtonPressed(_ sender: UIButton) {
        makeTableViewHeight()
    }
    
}

//MARK: - UI Functions
extension WrittingViewController {
    func setCountryButton() {
        country1.setTitle(countryName1, for: .normal)
        country2.setTitle(countryName2, for: .normal)
        country3.setTitle(countryName3, for: .normal)
        let width1 = countryName1 != nil ? 1 : 0
        let width2 = countryName2 != nil ? 1 : 0
        let width3 = countryName3 != nil ? 1 : 0
        makeCircle(target: country1, color: "MintBlue", width: width1)
        makeCircle(target: country2, color: "MintBlue", width: width2)
        makeCircle(target: country3, color: "MintBlue", width: width3)
        if countryName1 == nil && countryName2 == nil && countryName3 == nil {
            countryQuestionButton.isHidden = false
        } else {
            countryQuestionButton.isHidden = true
        }
    }
    
    func placeholderSetting() {
        titleTextView.text = "제목을 입력해주세요."
        titleTextView.textColor = UIColor(named: "Gray4")
        titleTextView.font = UIFont(name: "NotoSansKR-Regular", size: 24)
        mainTextView.text = "당신이 다녀왔던 생생한 여행경험은 무엇인가요?"
        mainTextView.textColor = UIColor(named: "Gray4")
        tailTextView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
        tailTextView.textColor = UIColor(named: "Gray4")
    }
    
    func popUpToast(_ string: String) {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: string, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeTableViewHeight() {
        addImageTableView.layoutIfNeeded()
        addImageTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = addImageTableView.contentSize.height
            }
        }
    }
}

//MARK: - UITextViewDelegate
extension WrittingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case titleTextView:
            // 줄바꿈 제한, 본문으로 넘어가기
            if text == "\n" {
                mainTextView.becomeFirstResponder()
            }
            // Title 글자수 제한
            guard let str = titleTextView.text else { return true }
            let length = str.count + text.count - range.length
            print(length)
            return length <= 31
        default:
            // Title 글자수 제한
            guard let str = textView.text else { return true }
            let length = str.count + text.count - range.length
            print(length)
            return length <= 2000
        }
    }
    
    // TextView Line에 따라 동적 height조절
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width-40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Gray4") {
            switch textView {
            case titleTextView:
                textView.text = nil
                textView.textColor = UIColor(named: "Gray1")
                textView.font = UIFont(name: "NotoSansKR-Bold", size: 24)
            default:
                textView.text = nil
                textView.textColor = UIColor(named: "Gray2")
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch textView {
            case titleTextView:
                textView.text = "제목을 입력해주세요."
                textView.textColor = UIColor(named: "Gray4")
                textView.font = UIFont(name: "NotoSansKR-Regular", size: 24)
            case mainTextView:
                textView.text = "당신이 다녀왔던 생생한 여행경험은 무엇인가요?"
                textView.textColor = UIColor(named: "Gray4")
            default:
                textView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
                textView.textColor = UIColor(named: "Gray4")
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension WrittingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath) as! AddImageTableViewCell
        makeBorder(target: cell.experienceTextViewBorder, radius: 12, isFilled: true)
        cell.experienceImage.image = imageArr[indexPath.row]
        cell.experienceTextView.text = textArr[indexPath.row]
        cell.index = indexPath.row
        makeBorder(target: cell.experienceImage, radius: 12, isFilled: true)
        //삭제 델리게이트 설정
        cell.delegate = self
        
        cell.textChanged {[weak tableView, weak self] newText in
            self?.textArr[indexPath.row] = newText
            DispatchQueue.main.async {
                tableView?.beginUpdates()
                self?.makeTableViewHeight()
                tableView?.endUpdates()
            }
        }
        return cell
    }
}

//MARK: - DeleteImageDelegate
extension WrittingViewController: DeleteImageDelegate {
    func deleteImage(index: Int) {
        imageArr.remove(at: index)
        textArr.remove(at: index)
        if textArr.count == 0 {
            tailTextView.isHidden = true
        }
        addImageTableView.reloadData()
        makeTableViewHeight()
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension WrittingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func useCamera() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func useLibrary() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let image = viewModel.resizeImage(image: img, newWidth: 150)
            imageArr.append(image)
            textArr.append("사진에 대한 여행경험을 적어주세요.")
            addImageTableView.reloadData()
            makeTableViewHeight()
        }
        DispatchQueue.main.async {
            self.makeTableViewHeight()
            self.tailTextView.isHidden = false
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}
