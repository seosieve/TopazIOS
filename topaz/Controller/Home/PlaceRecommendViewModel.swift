//
//  PlaceRecommendViewModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/17.
//

import UIKit

class PlaceRecommendViewModel {
    func getImage(by countryName: String, getImageHandler: @escaping ([URL]) -> Void) {
        if let url = URL.withUnsplash(string: "search/photos?page=\(Int.random(in: 1...10))&per_page=5&query=\(countryName)") {
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
    
    func getImageAsync(by countryName: String) async throws {
        let urlString = "search/photos?page=\(Int.random(in: 1...10))&per_page=5&query=\(countryName)"
        guard let url = URL.withUnsplash(string: urlString) else { throw UnsplashError.invalidURL}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setAccessKey()
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else { throw UnsplashError.invalidResponse }
            print("Status Code: \(response.statusCode)")
            await UnsplashCountryAsync.shared.deleteAll()
            let searchResults = try JSONDecoder().decode(UnsplashResults.self, from: data)
            await UnsplashCountryAsync.shared.appendCountry(searchResults: searchResults)
        } catch {
            throw error
        }
    }
}


