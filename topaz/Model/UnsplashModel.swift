//
//  UnsplashModel.swift
//  topaz
//
//  Created by 서충원 on 2023/06/17.
//

import UIKit

struct UnsplashResults: Codable {
    let results: [ImageInfo]
}

struct ImageInfo: Codable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let urls: Urls
    let links: Links
    let user: Photographer
}

struct Urls: Codable {
    let full: String
    let regular: String
    let small: String
    var fullUrl: URL {
        return URL(string: full)!
    }
    var regularUrl: URL {
        return URL(string: regular)!
    }
    var smallUrl: URL {
        return URL(string: small)!
    }
}

struct Links: Codable {
    let html: String
}

struct Photographer: Codable {
    let name: String
}

//MARK: - Unsplash Error
enum UnsplashError: Error {
    case invalidURL
    case invalidResponse
    case invalidImage
}

//MARK: - Unsplash Base URL
extension URL {
    private static var unsplashBaseUrl: String {
        return "https://api.unsplash.com/"
    }
    static func withUnsplash(string: String) -> URL? {
        let urlString = "\(unsplashBaseUrl)\(string)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: encodedString)
    }
}

//MARK: - Unsplash Access Key
extension URLRequest {
    private static var accessKey: String {
        return "Client-ID 90F3-aRMjztqoF00rWwWbUW3g109EGHACjIQ_Kc5yQ4"
    }
    mutating func setAccessKey() {
        return setValue(URLRequest.accessKey, forHTTPHeaderField: "Authorization")
    }
}

//MARK: - UIImageView load with URL
extension UIImageView {
    static var cache = NSCache<AnyObject, UIImage>()
    
    func load(url: URL) {
        if let cachedImage = UIImageView.cache.object(forKey: url as AnyObject) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            print("You get image from cache")
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.contentMode = .scaleAspectFill
                            self?.image = image
                            if let imageView = self {
                                UIImageView.cache.setObject(imageView.image!, forKey: url as AnyObject)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadAsync(url: URL) async throws {
        if let cachedImage = UIImageView.cache.object(forKey: url as AnyObject) {
            print("You get image from cache")
            self.image = cachedImage
        } else {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.contentMode = .scaleAspectFill
                    self.image = image
                    UIImageView.cache.setObject(self.image!, forKey: url as AnyObject)
                } else {
                    throw UnsplashError.invalidImage
                }
            } catch {
                throw error
            }
        }
    }
    
    func loadWithHandler(url: URL, loadImageHandler: @escaping () -> Void) {
        if let cachedImage = UIImageView.cache.object(forKey: url as AnyObject) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            print("You get image from cache")
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.contentMode = .scaleAspectFill
                            self?.image = image
                            loadImageHandler()
                            UIImageView.cache.setObject(self!.image!, forKey: url as AnyObject)
                        }
                    }
                }
            }
        }
    }
}
