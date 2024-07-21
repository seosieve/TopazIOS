//
//  ContinentModel.swift
//  topaz
//
//  Created by 서충원 on 7/21/24.
//

import Foundation

enum Continent: String, CaseIterable {
    case asia = "아시아"
    case europe = "유럽"
    case africa = "아프리카"
    case oceania = "오세아니아"
    case northAmerica = "북아메리카"
    case southAmerica = "남아메리카"
    
    static var allContinents: [String] {
        return Continent.allCases.map{ $0.rawValue }
    }
}
