//
//  WrittingViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import UIKit
import Firebase
import Lottie
import Kingfisher

class WrittingViewController: UIViewController {

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
    @IBOutlet weak var addMusicButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    let viewModel = WrittingViewModel()
    private let imagePicker = UIImagePickerController()
    
    let articleID = Firestore.firestore().collection("Articles").document().documentID
    var selectedCountryArr = [String]()
    var imageUrlArr = [String]()
    var imageNameArr = [Int]()
    var textArr = [String]()
    let backgroundView = UIView()
    let lottieView = AnimationView(name: "Loading")
    
    var musicArr = ["", "", "", ""]
    var volumeArr: [Float] = [0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeCircle(target: registerButton, color: "MintBlue", width: 0)
        makeCircle(target: addMusicButton, color: "MintBlue", width: 0)
        makeCircle(target: addImageButton, color: "MintBlue", width: 0)
        makeShadow(target: addMusicButton, radius: addImageButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        makeShadow(target: addImageButton, radius: addImageButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        writtingScrollView.addGestureRecognizer(tapGestureReconizer)
        
        titleTextView.delegate = self
        mainTextView.delegate = self
        tailTextView.delegate = self
        
        addImageTableView.register(WrittingAddImageTableViewCell.nib(), forCellReuseIdentifier: "WrittingAddImageTableViewCell")
        addImageTableView.delegate = self
        addImageTableView.dataSource = self
        
        imagePicker.delegate = self
        
        placeholderSetting()
        makeTableViewHeight()
        tailTextView.isHidden = true
    }
    
    //touchesBegan을 대신해서 쓰임
    @objc func tabScrollView() {
        titleTextView.endEditing(true)
        mainTextView.endEditing(true)
        tailTextView.endEditing(true)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        for timeStamp in imageNameArr {
            viewModel.deleteExperienceImage(articleID, timeStamp) {
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let countryArr = viewModel.makeCountry(countryButton)
        // 실패일 때 ToastMessage
        if countryArr.count == 0 {
            popUpToast("어느 나라에 대한 여행경험인가요? 궁금해요.")
        } else if titleTextView.textColor == UIColor(named: "Gray4") {
            popUpToast("당신의 여행경험의 제목을 지어주세요.")
        } else if mainTextView.textColor == UIColor(named: "Gray4") {
            popUpToast("좀 더 자세한 여행경험을 듣고싶어요!")
        } else {
            // 재확인 AlertMessage
            confirmRegisterAlert()
        }
    }
    
    @IBAction func addCountryButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddCountry", sender: sender)
    }
    
    @IBAction func addMusicButtonPressed(_ sender: UIButton) {
        
        
        
        
        instantiateVC()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddCountry" {
            let destinationVC = segue.destination as! CountryAddViewController
            destinationVC.selectedCountryArr = selectedCountryArr
            destinationVC.countryDelegate = self
        }
    }
}

//MARK: - UI Functions
extension WrittingViewController {
    func setCountryButton(selectedCountryArr: [String]) {
        let countryArrCount = selectedCountryArr.count
        countryButton.forEach { button in
            makeCircle(target: button, width: 0)
            button.setTitle(nil, for: .normal)
        }
        if countryArrCount == 0 {
            countryQuestionButton.isHidden = false
        } else {
            countryQuestionButton.isHidden = true
            for index in 0...countryArrCount-1 {
                countryButton[index].setTitle(selectedCountryArr[index], for: .normal)
                makeCircle(target: countryButton[index], width: 1)
            }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func confirmRegisterAlert() {
        let alert = UIAlertController(title: "여행경험을 등록할까요?", message: nil, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "아니오", style: .cancel)
        let register = UIAlertAction(title: "예", style: .default) { action in
            // 성공일 때 Animation
            loadingAnimation(self.backgroundView, self.lottieView, view: self.view)
            self.registerButton.isEnabled = false
            self.view.endEditing(true)
            let imageText = self.viewModel.makeImageText(imageText: self.textArr)
            let tailText = self.viewModel.makeTailText(tailText: self.tailTextView)
            
            self.viewModel.addArticle(articleID: self.articleID, country: self.viewModel.makeCountry(self.countryButton), title: self.titleTextView, mainText: self.mainTextView, imageText: imageText, imageName: self.imageNameArr, imageUrl: self.imageUrlArr, tailText: tailText) {
                self.backgroundView.removeFromSuperview()
                self.lottieView.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
        }
        cancle.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        alert.addAction(cancle)
        alert.addAction(register)
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeTableViewHeight() {
        addImageTableView.layoutIfNeeded()
        addImageTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = addImageTableView.contentSize.height
            }
        }
    }
    
    func instantiateVC() {
        let storyboard = UIStoryboard(name: "Community", bundle: .main)
        let MusicVC = storyboard.instantiateViewController(withIdentifier: "MusicVC")
        let destinationVC = MusicVC as! MusicAddViewController
        destinationVC.musicAddDelegate = self
        destinationVC.musicArr = musicArr
        destinationVC.volumeArr = volumeArr
        MusicVC.modalPresentationStyle = .automatic
        MusicVC.modalTransitionStyle = .coverVertical
        self.present(MusicVC, animated: true, completion: nil)
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
            return length <= 31
        default:
            // Title 글자수 제한
            guard let str = textView.text else { return true }
            let length = str.count + text.count - range.length
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
        return imageUrlArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WrittingAddImageTableViewCell", for: indexPath) as! WrittingAddImageTableViewCell
        cell.selectionStyle = .none
        makeBorder(target: cell.experienceTextViewBorder, radius: 12, isFilled: true)
        let url = URL(string: imageUrlArr[indexPath.row])!
        cell.experienceImage.kf.setImage(with: url)
        cell.experienceTextView.text = textArr[indexPath.row]
        // Image 지웠을 때 기존 cell색 따라가는 이슈 대응
        if cell.experienceTextView.text == "사진에 대한 여행경험을 적어주세요." {
            cell.experienceTextView.textColor = UIColor(named: "Gray4")
        } else {
            cell.experienceTextView.textColor = UIColor(named: "Gray2")
        }
        
        cell.index = indexPath.row
        makeBorder(target: cell.experienceImage, radius: 12, color: "Gray6", isFilled: false)
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
        viewModel.deleteExperienceImage(articleID, imageNameArr[index]) {
            self.imageNameArr.remove(at: index)
            self.imageUrlArr.remove(at: index)
            self.textArr.remove(at: index)
            if self.textArr.count == 0 {
                self.tailTextView.isHidden = true
                self.tailTextView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
                self.tailTextView.textColor = UIColor(named: "Gray4")
            }
            self.addImageTableView.reloadData()
            self.makeTableViewHeight()
        }
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
            viewModel.addExperienceImage(articleID, image) { url, timeStamp in
                self.imageUrlArr.append(url)
                self.imageNameArr.append(timeStamp)
                self.textArr.append("사진에 대한 여행경험을 적어주세요.")
                self.addImageTableView.reloadData()
                self.makeTableViewHeight()
                DispatchQueue.main.async {
                    self.makeTableViewHeight()
                    self.tailTextView.isHidden = false
                    self.imagePicker.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

//MARK: - transferCountryDelegate
extension WrittingViewController: AddCountryDelegate {
    // 다녀온 나라 정보값 받아오기
    func addCountry(selectedCountryArr: [String], addCountryHandler: @escaping () -> ()) {
        self.selectedCountryArr = selectedCountryArr
        setCountryButton(selectedCountryArr: selectedCountryArr)
        addCountryHandler()
    }
}

extension WrittingViewController: MusicAddDelegate {
    func musicAdd(musicArr: [String], volumeArr: [Float], musicHandler: @escaping () -> ()) {
        self.musicArr = musicArr
        self.volumeArr = volumeArr
        print(volumeArr)
        musicHandler()
    }
}
