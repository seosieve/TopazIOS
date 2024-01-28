//
//  ContinentRecommendViewModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/20.
//

import UIKit

class ContinentRecommendViewModel {
    func getCountry(getCountryHandler: @escaping ([RestCountryResults]) -> Void) {
        if let url = URL.withRestCountry(string: "all") {
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
    
    func getCountry(byContinent text: String, getCountryHandler: @escaping ([RestCountryResults]) -> Void) {
        if let url = URL.withRestCountry(string: "region/\(text)") {
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
    
    func getCountry(byName text: String, getCountryHandler: @escaping ([RestCountryResults]) -> Void) {
        if let url = URL.withRestCountry(string: "translation/\(text)") {
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
                        getCountryHandler([RestCountryResults]())
                    }
                }
            }.resume()
        }
    }
    
    func getImage(by countryName: String, getImageHandler: @escaping (UnsplashResults?) -> Void) {
        if let url = URL.withUnsplash(string: "search/photos?page=1&per_page=1&query=\(countryName)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setAccessKey()
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
//                    if let rateRemaining = response.allHeaderFields["x-ratelimit-remaining"] as? String {
//                        print(rateRemaining)
//                    }
                    do {
                        let searchResults = try JSONDecoder().decode(UnsplashResults.self, from: data)
                        if searchResults.results.isEmpty {
                            getImageHandler(nil)
                        } else {
                            getImageHandler(searchResults)
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
