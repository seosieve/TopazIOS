//
//  ModifyViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/13.
//

import UIKit
import Firebase
import Lottie
import Kingfisher
import SwiftySound

protocol ModifyArticleDelegate {
    func modifyArticle(modifyArticleHandler: @escaping () -> ())
    func cancle()
}

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
    @IBOutlet weak var modifyImageTableView: UITableView!
    @IBOutlet weak var modifyImageTableViewConstraintY: NSLayoutConstraint!
    @IBOutlet weak var addMusicButton: UIButton!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var addImageButton: UIButton!
    
    let viewModel = ModifyViewModel()
    private let imagePicker = UIImagePickerController()
    var modifyDelegate: ModifyArticleDelegate?
    
    var article: Article?
    var selectedCountryArr = [String]()
    var imageUrlArr = [String]()
    var imageNameArr = [Int]()
    var textArr = [String]()
    var musicNameArr = ["", "", "", ""]
    var musicVolumeArr: [Float] = [0, 0, 0, 0]
    var musicPlayArr = [Sound?]()
    let backgroundView = UIView()
    let lottieView = LottieAnimationView(name: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUrlArr = article!.imageUrl
        imageNameArr = article!.imageName
        makeCircle(target: registerButton, color: "MintBlue", width: 0)
        makeCircle(target: addImageButton, color: "MintBlue", width: 0)
        makeCircle(target: addMusicButton, color: "MintBlue", width: 0)
        makeShadow(target: addImageButton, radius: addImageButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        makeShadow(target: addMusicButton, radius: addImageButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        writtingScrollView.addGestureRecognizer(tapGestureReconizer)
        
        titleTextView.delegate = self
        mainTextView.delegate = self
        tailTextView.delegate = self

        modifyImageTableView.register(ModifyImageTableViewCell.nib(), forCellReuseIdentifier: "ModifyImageTableViewCell")
        modifyImageTableView.delegate = self
        modifyImageTableView.dataSource = self
        
        imagePicker.delegate = self
        
        modifyArticleUI()
    }
    
    //touchesBegan을 대신해서 쓰임
    @objc func tabScrollView() {
        titleTextView.endEditing(true)
        mainTextView.endEditing(true)
        tailTextView.endEditing(true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        musicPlayArr.forEach { music in
            music?.fadeOutStop()
        }
        modifyDelegate?.cancle()
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
        self.performSegue(withIdentifier: "goToModifyCountry", sender: sender)
    }
    
    @IBAction func addMusicButtonPressed(_ sender: UIButton) {
        instantiateVC()
    }
    
    @IBAction func musicSwitchChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            playMusic()
        } else {
            pauseMusic()
        }
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
        if segue.identifier == "goToModifyCountry" {
            let destinationVC = segue.destination as! CountryModifyViewController
            destinationVC.selectedCountryArr = selectedCountryArr
            destinationVC.countryDelegate = self
        }
    }
}

//MARK: - UI Functions
extension ModifyViewController {
    func modifyArticleUI() {
        // 음악 설정
        if article!.musicName == ["", "", "", ""] {
            musicSwitch.isHidden = true
        } else {
            musicNameArr = article!.musicName
            musicVolumeArr = article!.musicVolume
            setMusic()
        }
        // 여행국가 설정
        let countryCount = article!.country.count
        countryQuestionButton.isHidden = true
        for index in 0...countryCount-1 {
            selectedCountryArr.append(article!.country[index])
            countryButton[index].setTitle(article!.country[index], for: .normal)
            makeCircle(target: countryButton[index], width: 1)
        }
        // 글 부분 설정
        titleTextView.text = article!.title
        mainTextView.text = article!.mainText
        if article!.imageText.count == 0 {
            tailTextView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
            tailTextView.textColor = UIColor(named: "Gray4")
            tailTextView.isHidden = true
        } else {
            if article!.tailText == "" {
                tailTextView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
                tailTextView.textColor = UIColor(named: "Gray4")
            } else {
                tailTextView.text = article!.tailText
            }
        }
        for imageText in article!.imageText {
            if imageText == "" {
                textArr.append("사진에 대한 여행경험을 적어주세요.")
            } else {
                textArr.append(imageText)
            }
        }
        // Maximum Size Constraint 설정
        let cellCount = CGFloat(article?.imageText.count ?? 0)
        let cellHeight = view.frame.height
        modifyImageTableViewConstraintY.constant = cellCount * cellHeight
        // VisibleCells를 통해 Constraint 재설정
        modifyImageTableView.layoutIfNeeded()
        let cells = modifyImageTableView.visibleCells
        var contentSizeHeight: CGFloat = 0.0
        for cell in cells {
            contentSizeHeight += cell.frame.height
        }
        modifyImageTableViewConstraintY.constant = contentSizeHeight
    }
    
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
        let alert = UIAlertController(title: "여행경험 수정을 완료할까요?", message: nil, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "아니오", style: .cancel)
        let register = UIAlertAction(title: "예", style: .default) { action in
            // 성공일 때 Animation
            loadingAnimation(self.backgroundView, self.lottieView, view: self.view)
            self.registerButton.isEnabled = false
            self.view.endEditing(true)
            let articleID = self.article!.articleID
            let imageText = self.viewModel.makeImageText(imageText: self.textArr)
            let tailText = self.viewModel.makeTailText(tailText: self.tailTextView)
            let likes = self.article!.likes
            let views = self.article!.views
            
            self.viewModel.modifyArticle(articleID: articleID, country: self.viewModel.makeCountry(self.countryButton), title: self.titleTextView, mainText: self.mainTextView, imageText: imageText, imageName: self.imageNameArr, imageUrl: self.imageUrlArr, musicName: self.musicNameArr, musicVolume: self.musicVolumeArr, tailText: tailText, likes: likes, views: views) {
                self.modifyDelegate?.modifyArticle {
                    self.backgroundView.removeFromSuperview()
                    self.lottieView.removeFromSuperview()
                    self.musicPlayArr.forEach { music in
                        music?.fadeOutStop()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        cancle.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        alert.addAction(cancle)
        alert.addAction(register)
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeTableViewHeight() {
        modifyImageTableView.layoutIfNeeded()
        modifyImageTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = modifyImageTableView.contentSize.height
            }
        }
    }
    
    func instantiateVC() {
        musicPlayArr.forEach { music in
            music?.fadeOutStop()
        }
        let storyboard = UIStoryboard(name: "Community", bundle: .main)
        let MusicVC = storyboard.instantiateViewController(withIdentifier: "MusicVC")
        let destinationVC = MusicVC as! MusicAddViewController
        destinationVC.musicAddDelegate = self
        destinationVC.musicNameArr = musicNameArr
        destinationVC.musicVolumeArr = musicVolumeArr
        MusicVC.modalPresentationStyle = .automatic
        MusicVC.modalTransitionStyle = .coverVertical
        self.present(MusicVC, animated: true, completion: nil)
    }
    
    func setMusic() {
        DispatchQueue.global().async {
            self.musicPlayArr = [Sound?]()
            for (index,musicName) in self.musicNameArr.enumerated() {
                if musicName != "" {
                    let url = Bundle.main.url(forResource: musicName, withExtension: "mp3")!
                    let sound = Sound(url: url)!
                    self.musicPlayArr.append(sound)
                    sound.play(numberOfLoops: -1)
                    sound.volume = self.musicVolumeArr[index]
                }
            }
        }
    }
    
    func playMusic() {
        DispatchQueue.global().async {
            for sound in self.musicPlayArr {
                sound?.resume()
            }
        }
    }
    
    func pauseMusic() {
        DispatchQueue.global().async {
            for sound in self.musicPlayArr {
                sound?.pause()
            }
        }
    }
}

//MARK: - UITextViewDelegate
extension ModifyViewController: UITextViewDelegate {
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
extension ModifyViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrlArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModifyImageTableViewCell", for: indexPath) as! ModifyImageTableViewCell
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
            print(self!.textArr[indexPath.row])
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
extension ModifyViewController: ModifyImageDelegate {
    func modifyImage(index: Int) {
        viewModel.deleteExperienceImage(article!.articleID, imageNameArr[index]) {
            self.imageNameArr.remove(at: index)
            self.imageUrlArr.remove(at: index)
            self.textArr.remove(at: index)
            if self.textArr.count == 0 {
                self.tailTextView.isHidden = true
                self.tailTextView.text = "당신의 이야기의 끝맺음을 듣고싶어요."
                self.tailTextView.textColor = UIColor(named: "Gray4")
            }
            self.modifyImageTableView.reloadData()
            self.makeTableViewHeight()
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            viewModel.modifyExperienceImage(article!.articleID, image) { url, timeStamp in
                self.imageUrlArr.append(url)
                self.imageNameArr.append(timeStamp)
                self.textArr.append("사진에 대한 여행경험을 적어주세요.")
                self.modifyImageTableView.reloadData()
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

//MARK: - ModifyCountryDelegate
extension ModifyViewController: ModifyCountryDelegate {
    // 다녀온 나라 정보값 받아오기
    func modifyCountry(selectedCountryArr: [String], modifyCountryHandler: @escaping () -> ()) {
        self.selectedCountryArr = selectedCountryArr
        setCountryButton(selectedCountryArr: selectedCountryArr)
        modifyCountryHandler()
    }
}

//MARK: - MusicAddDelegate
extension ModifyViewController: MusicAddDelegate {
    func musicAdd(musicNameArr: [String], musicVolumeArr: [Float], musicHandler: @escaping () -> ()) {
        self.musicNameArr = musicNameArr
        self.musicVolumeArr = musicVolumeArr
        if musicNameArr == ["", "", "", ""] {
            musicPlayArr = [Sound?]()
            musicSwitch.isOn = false
            musicSwitch.isHidden = true
        } else {
            setMusic()
            musicSwitch.isHidden = false
            musicSwitch.isOn = true
        }
        musicHandler()
    }
}
