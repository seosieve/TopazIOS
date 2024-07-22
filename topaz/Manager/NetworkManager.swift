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
    
    func getMemoryImage(fileName: String) -> UIImage? {
        return cache.object(forKey: fileName as NSString)
    }
    
    func getDiskImage(fileName: String) -> UIImage? {
        return repository.loadImage(fileName: fileName)
    }
    
    func getImage(urlString: String, fileName: String, completion: @escaping (UIImage) -> Void) {
        ///Memory Caching
        if let cachedImage = getMemoryImage(fileName: fileName) {
            completion(cachedImage)
            return
        }
        ///Disk Caching
        if let diskImage = getDiskImage(fileName: fileName) {
            ///Set Memory Cache
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
                ///Set Memory Cache
                self?.cache.setObject(image, forKey: fileName as NSString)
                ///Set Disk Cache
                self?.repository.addImage(image: image, fileName: fileName)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
}


