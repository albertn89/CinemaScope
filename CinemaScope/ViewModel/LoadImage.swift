//
//  LoadImage.swift
//  CinemaScope
//
//  Created by Albert Negoro on 4/18/23.
//

import Foundation
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class LoadImage: ObservableObject {
    
    @Published var bgImage: UIImage?
    @Published var isLoading = false

    var imageCache = _imageCache
    
    func loadImg(with url: URL) {
        let urlString = url.absoluteString
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.bgImage = imageFromCache
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            
            guard let self = self else {
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                
                DispatchQueue.main.async { [weak self] in
                    self?.bgImage = image
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
}
