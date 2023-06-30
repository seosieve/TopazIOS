//
//  ContinentRecommendViewModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/20.
//

import UIKit

class ContinentRecommendViewModel {
    func getCountry(getCountryHandler: @escaping ([RestCountryResults]) -> Void) {
        if let url = URL.withRestCountry(string: "all?fields=name,translations,flags,capital") {
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
        if let url = URL.withRestCountry(string: "region/\(text)?fields=name,translations,flags,capital") {
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
        if let url = URL.withRestCountry(string: "translation/\(text)?fields=name,translations,flags,capital") {
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
    
    func getImage(by countryName: String, getImageHandler: @escaping ([URL]) -> Void) {
        if let url = URL.withUnsplash(string: "search/photos?page=1&per_page=1&query=\(countryName)") {
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
                        let searchResults = try JSONDecoder().decode(UnsplashResults.self, from: data)
                        searchResults.results.forEach { result in
                            UrlArr.append(result.urls.smallUrl)
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
