//
//  CountryDetailViewModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/23.
//

import UIKit

class CountryDetailViewModel {
    func getCountry(byName text: String, getCountryHandler: @escaping ([RestCountryResults]) -> Void) {
        if let url = URL.withRestCountry(string: "name/\(text)?fields=name,translations,flags,capital") {
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
