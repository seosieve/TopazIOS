# TOPAZ - 모바일로 경험하는 세계여행 <img src="https://github.com/user-attachments/assets/7706edaa-1da4-45ad-8d38-7c7b90267400" width="30" height="30">
> Trip On Smart Phone A-Z, TOPAZ
<br>
<br>

<div align="center">
  <img src="https://github.com/seosieve/TopazIOS/assets/76729543/bf153ad9-ba4b-4dcd-a13a-1c64eacbb960" width="150" height="150">
  <br>
  <br>
  <img src="https://img.shields.io/badge/Swift-v5.0-red?logo=swift"/>
  <img src="https://img.shields.io/badge/Xcode-v15.0-blue?logo=Xcode"/>
  <img src="https://img.shields.io/badge/iOS-14.0+-black?logo=apple"/>  
  <br>
  <br>
  <a href="https://apps.apple.com/kr/app/topaz/id1589188867" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 180px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-US?size=250x83&amp" alt="Download on the App Store" style="border-radius: 13px; width: 180px; height: 83px;"></a>
</div>

<div align="center">
  <br>
  <img src="https://github.com/seosieve/TopazIOS/assets/76729543/2741e194-9176-498b-b3df-aaebfa8ab5fb" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/47a43577-9195-419f-8955-19cbbc9e3976" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/32af170b-bd75-4403-9088-a6a8738dc86e" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/bb7a0500-e432-448e-a0e9-15453a0a8f5b" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/f7ab2a41-f783-4643-be66-726fe1a31b1e" width="19%">
</div>
<br>

## 프로젝트 소개
`🌎 여행을 가기엔 시간도, 상황도 안되는 요즘, 저희가 생생한 여행경험을 통해 여행의 즐거움을 다시 느끼게 해드릴게요!`
> **나만의 커스텀 배경 음악과 함께 여행 경험을 공유**할 수 있는 앱 서비스
<br>

## 프로젝트 주요 기능
- 이메일 회원가입, 로그인 기능
- 시간대에 따라 다른 테마의 **인터렉티브 지구** 홈화면
- 대륙에 따른 여행지 추천, 검색 기능
- 커뮤니티 게시글 **작성 / 수정 / 삭제 / 검색**
- 게시글과 함께 작성할 수 있는 **커스텀 배경음악** 기능
- **내가 쓴 글, 프로필, 차단유저, 여행등급, 수집품** 관리 기능
<br>

## 프로젝트 개발 환경
- 개발 인원
  - 디자이너 2명, iOS개발 1명
- 개발 기간
  - 2022.09 - 2022.12 (3개월)
- iOS 최소 버전
  - iOS 14.0+
<br>

## 프로젝트 기술 스택
- **활용기술 및 키워드**
  - **iOS** : swift 5.8, xcode 15.0.1, UIKit, SceneKit
  - **Network** : URLSession, Firebase
  - **UI** : StoryBoard

- **라이브러리**

라이브러리 | 사용 목적 | Version
:---------:|:----------:|:---------:
SwiftySound | 배경음악 처리 | -
Kingfisher | 이미지 처리 | 7.0
lottie-ios | 스플래시, 로딩 인디케이터 | -
<br>

## 프로젝트 아키텍처
<div align="center">
  <img src="https://github.com/user-attachments/assets/a9c0ae36-70e4-4fbf-a753-4b2bce2170dc">
</div>
<br>

> StoryBoard + MVVM Architecture
- 3D Base UI등 Custom UI가 많아 커뮤니케이션과 전체적인 UI Flow관찰을 위해 StoryBoard 활용
- Manager객체에서 API Fetching 및 FireBase CRUD 구현 로직을 담당, ViewModel에서 호출
- Auth Token 저장 및 UserID 등 불필요한 API Call을 줄이기 위해 UserDefaults 저장소 병용
<br>

## 트러블 슈팅
### 1. SceneView에서 사용자 Interaction이 작동하지 않는 문제
> 3D재질 맵핑을 SCN객체 전체에 하다보니 나눠져있던 객체 모듈들을 인식하지 못하는 문제 발생
<div align="center">
  <img src="https://github.com/user-attachments/assets/18bb0b75-a054-4d20-8b31-33c37716679e" width="75%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/7805f425-dc4b-4982-adad-e003bac1d819" width="11.8%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/17986f98-59c3-4ff6-9216-df4dea40c17b" width="11.8%"> 
</div>
<br>

- Interaction을 담당하는 SCN파일과 UI를 담당하는 SCN파일을 나눠서 SCNScene을 각각 제작
- hitTest함수를 통해 SCNView의 Geometry Name에 접근, 각각의 Enum값과 결과 맵핑
```swift
class EarthNode: SCNNode {
    override init() {
        super.init()
        //Interaction SCNScene
        let earthBound = SCNScene(named: "Assets.scnassets/earth_isolate.scn")!
        let earthBoundArr = earthBound.rootNode.childNodes
        earthBoundArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
        //UI SCNScene
        let earth = SCNScene(named: "Assets.scnassets/Earth.scn")!
        let earthArr = earth.rootNode.childNodes
        earthArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
```
```swift
let point = gestureRecognize.location(in: sceneView)
let hitResults = sceneView.hitTest(point, options: [:])
if hitResults.count > 0 {
    let result = hitResults[0]
    guard let continentTitle = result.node.geometry?.name else { return }
    if continent.continentName.contains(continentTitle) {
        continentButton.setTitle(continentTitle, for: .normal)
        if let count = continent.continentName.firstIndex(of: continentTitle) {
            continentCount = count
        }
    }
}
```
<br>

### 2. 사용자가 지정한 배경음악을 FireBase 저장소에 저장
> 사용자가 커스텀한 배경음악을 FireBase Storage에 저장할 때, 음악 파일 자체를 저장하면 같은 음악 파일이 중복되어 저장되는 상황이 발생
<div align="center">
  <img src="https://github.com/user-attachments/assets/1498f478-5e41-4333-8a5e-ae26a6433f2d" width="75%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/f7ab2a41-f783-4643-be66-726fe1a31b1e" width="11.8%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/97311dfb-fce7-4eaf-ba5a-ccc064526551" width="11.8%"> 
</div>
<br>

- mp3파일이 아닌 '선택된 음악 이름'과 '사운드 값'를 String과 Int 배열로 저장하는 방식으로 접근
- 현재 재생되고있는 음악의 사운드 값을 Volume이라는 인스턴스로 제공해주는 **SwiftySound** 프레임워크 발견, 사용
- 사용자의 PanGesture의 point값과 volume을 연동시키고, 이를 배열로 저장해서 FireBase에 저장
```swift
var soundEffectArr = [Sound?]()
var musicNameArr = Array(repeating: "", count: 4)

func playBackgroundMusic(fileName: String, isFirst: Bool = false) {
    DispatchQueue.global().async {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        self.backgroundMusic = Sound(url: url)
        self.backgroundMusic!.play(numberOfLoops: -1)
        let volume = isFirst ? self.musicVolumeArr[0] : 0.5
        self.backgroundMusic?.volume = volume
    }
}

@objc func drag(sender: UIPanGestureRecognizer) {
    //드래그 했을 때의 위치
    let translation = sender.translation(in: self.view)
    let x = sender.view!.center.x
    sender.setTranslation(.zero, in: self.view)
    //부가요소들 또한 같이 움직이게 설정
    let index = sender.view!.tag
    progressBarProgress[index-1].constraints.forEach { constraint in
        if constraint.firstAttribute == .height {
            constraint.constant = 1.1 * (180 - sender.view!.center.y)
        }
    }
    //소수점값에 따라 Sound volume 조절
    let volumeFloat = Float(0.009 * (170 - sender.view!.center.y))
    if index == 1 {
        backgroundMusic?.volume = volumeFloat
    } else {
        if sender.view?.subviews.first?.alpha != 0 {
            soundEffectArr[index-2]?.volume = volumeFloat
        }
    }
}
```
### 메모리적 이점
- 변경 후, 게시글 하나당 평균 용량 4.05MB에서 1.87MB로 감소
- Storage 전체 용량도 398MB에서 121MB로 감소
<div align="center">
  <img src="https://github.com/user-attachments/assets/68184718-48f5-44ee-859a-c99d5db8c1c3">
</div>
<br>

### 3. Unsplash API 메모리 & 디스크 캐싱
> 각 나라별로 API Call을 하다보니 API 한도가 너무 빨리 소모되는 상황이 발생
<div align="center">
  <img src="https://github.com/user-attachments/assets/314565b1-6dd5-4bdc-b86b-40840277d4bb" width="75%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/32af170b-bd75-4403-9088-a6a8738dc86e" width="11.8%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/47a43577-9195-419f-8955-19cbbc9e3976" width="11.8%"> 
</div>
<br>

- NSCache를 이용한 메모리 캐싱과 FileManager을 이용한 디스크 캐싱을 함께 사용
- FileManager 저장 시, 1시간 단위의 만료 기간을 UserDefaults에 함께 저장, API Call 초기화 주기와 Sync
- UIImage 리사이징을 통해 파일시스템 용량의 과중화 또한 방지
```swift
func getImage(urlString: String, fileName: String, completion: @escaping (UIImage) -> Void) {
    //Memory Caching
    if let cachedImage = getMemoryImage(fileName: fileName) {
        completion(cachedImage)
        return
    }
    //Disk Caching
    if let diskImage = getDiskImage(fileName: fileName) {
        //Set Memory Cache
        cache.setObject(diskImage, forKey: fileName as NSString)
        completion(diskImage)
        return
    }
    
    guard let url = URL(string: urlString) else { return }
    let urlRequest = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
        if let error = error {
            print(error)
        } else if let response = response as? HTTPURLResponse, let data = data {
            print("Status Code: \(response.statusCode)")
            guard let image = UIImage(data: data) else { return }
            //Set Memory Cache
            self?.cache.setObject(image, forKey: fileName as NSString)
            //Set Disk Cache
            self?.repository.addImage(image: image, fileName: fileName)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }.resume()
}
```
### 비용적, 사용자적 이점
- 변경 후, 게시글 하나당 평균 용량 4.05MB에서 1.87MB로 감소















