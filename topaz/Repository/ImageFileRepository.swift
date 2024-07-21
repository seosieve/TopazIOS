//
//  ImageFileRepository.swift
//  topaz
//
//  Created by 서충원 on 7/21/24.
//

import UIKit

final class ImageFileRepository {
    
    private let manager = FileManager.default
    
    private func fileURL(_ fileName: String) -> URL {
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("\(fileName).jpg")
    }
    
    func addImage(image: UIImage, fileName: String) {
        let data = image.jpegData(compressionQuality: 0.5)
        
        do {
            try data?.write(to: fileURL(fileName))
            print("Image Add Completed")
        } catch {
            print("Error Add Image: \(error.localizedDescription)")
        }
    }
    
    func deleteImage(_ fileName: String) {
        guard manager.fileExists(atPath: fileURL(fileName).path) else { return }
        
        do {
            try manager.removeItem(atPath: fileURL(fileName).path)
            print("Image Delete Completed")
        } catch {
            print("Error Delete Image: \(error.localizedDescription)")
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard manager.fileExists(atPath: fileURL(fileName).path) else { return nil }
        return UIImage(contentsOfFile: fileURL(fileName).path)
    }
}

