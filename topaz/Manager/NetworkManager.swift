//
//  NetworkManager.swift
//  topaz
//
//  Created by 서충원 on 7/21/24.
//

import UIKit

final class NetworkManager {
    
    private let repository = ImageFileRepository()
    private let cache = NSCache<NSString, UIImage>()
    
    func getCachedImage(fileName: String) -> UIImage? {
        return cache.object(forKey: fileName as NSString)
    }
    
    func getDiskImage(fileName: String) -> UIImage? {
        return repository.loadImage(fileName: fileName)
    }
    
    func getImage(urlString: String, fileName: String, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = getCachedImage(fileName: fileName) {
            completion(cachedImage)
            return
        }
        
        if let diskImage = getDiskImage(fileName: fileName) {
            cache.setObject(diskImage, forKey: fileName as NSString)
            completion(diskImage)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            if let error = error {
                print(error)
            } else if let response = response as? HTTPURLResponse, let data = data {
                print("Status Code: \(response.statusCode)")
                guard let image = UIImage(data: data) else { return }
                self?.repository.addImage(image: image, fileName: fileName)
                self?.cache.setObject(image, forKey: fileName as NSString)
                print("NetworkImage")
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
}
