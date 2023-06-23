//
//  CountryModel.swift
//  topaz
//
//  Created by 서충원 on 2021/10/13.
//

import UIKit

struct Country {
    let countryImage = [UIImage(named: "England"), UIImage(named: "France"), UIImage(named: "Germany"), UIImage(named: "India"), UIImage(named: "Japan"), UIImage(named: "Philippine"), UIImage(named: "Taiwan"), UIImage(named: "Thailand"), UIImage(named: "USA")]
    let countryName = ["영국", "프랑스", "독일", "인도", "일본", "필리핀", "대만", "태국", "미국"]
}

struct MainCountry {
    let countryImage = [UIImage(named: "Main"), UIImage(named: "England"), UIImage(named: "France"), UIImage(named: "Germany"), UIImage(named: "India"), UIImage(named: "Japan"), UIImage(named: "Philippine"), UIImage(named: "Taiwan"), UIImage(named: "Thailand"), UIImage(named: "USA")]
    let countryName = ["메인","영국", "프랑스", "독일", "인도", "일본", "필리핀", "대만", "태국", "미국"]
}

struct RecommendCountry {
    let countryImage = [UIImage(named: "PhilippineImage"), UIImage(named: "TaiwanImage"), UIImage(named: "ItalyImage"), UIImage(named: "NetherlandsImage"), UIImage(named: "MexicoImage")]
    let countryName = ["필리핀", "대만", "이탈리아", "네덜란드", "멕시코"]
    let countryEnglishName = ["Philippine", "Taiwan", "Italy", "Netherlands", "Mexico"]
    let countryIntroduce = ["서태평양에 있는 7000여개의 섬으로 이루어진 필리핀은 맑은 바다와 열대과일이 유명한 휴양지로 섬 중에 유명한 세부와 보라카이에서의 스노쿨링과 카약 등의 액티비티는 관광객들에게 설렘을 줍니다.", "타이페이101타워가 트레이드마크인 대만은 야경을 감상하기 매우 적절한 동아시아의 국가입니다. 불교의 영향으로 풍등축제, 홍등, 사찰 등 불교 관련 볼거리가 많고 다양한 먹거리와 간식거리가 항상 사람들을 유혹합니다.", "남유럽과 지중해의 반도에 위치한 공화국인 이탈리아는 콜로세움, 피사의 사탑 등 고풍스러운 유적지가 두 눈을 압도하는 나라입니다. 지중해 최대의 섬인 시칠리아 섬은 꽃과 야생 식물의 천국으로 관광객들이 휴양과 레저 모두를 즐길 수 있게 해 줍니다.", "네덜란드는 서유럽과 카리브 제도에 걸쳐있는 네덜란드 왕국의 구성국입니다. 폭 넓은 복지와 값비싼 세금으로 유명한 네덜란드는 또한 풍차와 튤립축제가 유명합니다. 평화로운 분위기와 장엄한 풍경을 보고 있으면 마음이 편안해집니다.", "북아메리카 남부의 멕시코는 열정적인 분위기의 사람들과 망자의 날 등 특색있는 축제로 유명합니다. 마야 유적, 아즈텍 유적 등 역사깊은 유적지 또한 충분한 볼 거리가 될 것입니다. "]
}

class UnsplashCountry {
    var countryImage = Array(repeating: [URL](), count: 5)
}

struct Continent {
    let continentName = ["아시아", "유럽", "아프리카", "오세아니아", "북아메리카", "남아메리카"]
}

struct RestCountryResults: Codable {
    let flags: Flag
//    let coatOfArms: CoatOfArms
    let name: Name
    let capital: [String]
    let translations: Translations
}

struct Flag: Codable {
    let png: String
}

//struct CoatOfArms: Codable {
//    let png: String
//}

struct Name: Codable {
    let common: String
    let official: String
}

struct Translations: Codable {
    let kor: Kor
}

struct Kor: Codable {
    let common: String
}

//MARK: - Unsplash Base URL
extension URL {
    private static var restCountryBaseUrl: String {
        return "https://restcountries.com/v3.1/"
    }
    static func withRestCountry(string: String) -> URL? {
        let urlString = "\(restCountryBaseUrl)\(string)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: encodedString)
    }
}
