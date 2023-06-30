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
}

struct Urls: Codable {
    let regular: String
    let small: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
    var smallUrl: URL {
        return URL(string: small)!
    }
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
                            UIImageView.cache.setObject(self!.image!, forKey: url as AnyObject)
                        }
                    }
                }
            }
        }
    }
    
    func loadWithHandler(url: URL, loadImageHandler: @escaping (UIImage) -> Void) {
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
                            loadImageHandler(image)
                            UIImageView.cache.setObject(self!.image!, forKey: url as AnyObject)
                        }
                    }
                }
            }
        }
    }
}
