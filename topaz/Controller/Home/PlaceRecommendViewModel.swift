//
//  PlaceRecommendViewModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/17.
//

import UIKit

class PlaceRecommendViewModel {
    func getImage(by countryName: String, getImageHandler: @escaping ([URL]) -> Void) {
        if let url = URL.with(string: "search/photos?page=\(Int.random(in: 1...10))&per_page=5&query=\(countryName)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setAccessKey()
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
                    do {
                        var UrlArr = [URL]()
                        let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                        searchResults.results.forEach { result in
                            UrlArr.append(result.urls.regularUrl)
                        }
                        getImageHandler(UrlArr)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}


