//
//  ContinentRecommendViewModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/20.
//

import UIKit

class ContinentRecommendViewModel {
    func getCountry(by text: String, getCountryHandler: @escaping ([RestCountryResults]) -> Void) {
        if let url = URL.withRestCountry(string: "translation/\(text)?fields=name,translations,flags") {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
                    do {
                        let searchResults = try JSONDecoder().decode([RestCountryResults].self, from: data)
                        getCountryHandler(searchResults)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
